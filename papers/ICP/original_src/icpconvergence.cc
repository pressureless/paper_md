/*
Szymon Rusinkiewicz
Princeton University

icpconvergence.cc
Conduct an experiment to test ICP per-iteration convergence as a
function of initial misalignment.
*/

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include "TriMesh.h"
#include "TriMesh_algo.h"
#include "ICP_align.cc"
#include "ICP_iter.cc"
using namespace std;
using namespace trimesh;


// ICP Parameters
#define DESIRED_PAIRS 10000
#define APPROX_EPS 0.05f
#define REJECTION_THRESH_MULT 3.7f // convert median to sigma, then times 2.5


// Experiment Parameters
#define NUM_DATAPOINTS 17
#define MIN_ERR 0.01f
#define MAX_ERR 1.0f


// Compute average ground-truth vertex error produced by this xform.
// Uses all points.
float err(const TriMesh *mesh, const xform &xf)
{
	float sum = 0.0f;
	size_t nv = mesh->vertices.size();
#pragma omp parallel for reduction(+ : sum)
	for (size_t i = 0; i < nv; i++)
		sum += dist(mesh->vertices[i], xf * mesh->vertices[i]);
	return sum / nv;
}


// Converts pairs of random numbers in [0,1] to
// uniformly-distributed points on the sphere
template <class T = float>
static inline Vec<3,T> rnd2sph(const T &u, const T &v)
{
	T phi = u * T(M_2PI);
	T z = v * 2 - 1;
	T xy = sqrt(T(1) - sqr(z));
	return Vec<3,T>(xy * cos(phi), xy * sin(phi), z);
}


void usage(const char *myname)
{
	fprintf(stderr, "Usage: %s in1.ply in2.ply [variant] [ntrials]\n", myname);
	exit(1);
}

int main(int argc, char *argv[])
{
	if (argc < 3)
		usage(argv[0]);

	TriMesh *mesh1 = TriMesh::read(argv[1]);
	if (!mesh1)
		usage(argv[0]);

	TriMesh *mesh2 = TriMesh::read(argv[2]);
	if (!mesh2)
		usage(argv[0]);
	bool do_rejection = (strcmp(argv[1], argv[2]) != 0);
	printf("do_rejection = %d\n", do_rejection);

	ICP_Variant variant = VARIANT_SYMM;
	if (argc > 3)
		variant = (ICP_Variant) atoi(argv[3]);
	if (variant < 0 || variant > VARIANT_MITRA)
		usage(argv[0]);

	int ntrials = 10;
	if (argc > 4)
		ntrials = atoi(argv[4]);

	// Apply xforms
	xform xf1, xf2;
	xf1.read(xfname(argv[1]));
	apply_xform(mesh1, xf1);

	xf2.read(xfname(argv[2]));
	apply_xform(mesh2, xf2);

	// Put mesh2 at origin, with unit variance
	point com = point_center_of_mass(mesh2->vertices);
	trans(mesh1, -com);
	trans(mesh2, -com);

	float C[3][3];
	point_covariance(mesh2->vertices, C);
	float s = 1.0f / sqrt(C[0][0] + C[1][1] + C[2][2]);

	scale(mesh1, s);
	scale(mesh2, s);

	// Compute mesh properties
	mesh1->need_normals();
	mesh2->need_normals();
	if (variant == VARIANT_MITRA)
		mesh1->need_curvatures();

	KDtree *kd1 = new KDtree(mesh1->vertices);

	// Start the trials
	const float factor = pow(MIN_ERR / MAX_ERR, 1.0f / (NUM_DATAPOINTS - 1));
	vector<float> errs(NUM_DATAPOINTS);
	for (int trial = 0; trial < ntrials; trial++) {
		printf("%4d:   ", trial+1); fflush(stdout);
		// All of the initial transforms for a single trial will have
		// rotations about the same axis, and multiples of same trans
		vec rotaxis = rnd2sph(uniform_rnd(), uniform_rnd());
		vec transdir = rnd2sph(uniform_rnd(), uniform_rnd());
		float rotamount = uniform_rnd();
		float transamount = uniform_rnd();
		for (int x = 0; x < NUM_DATAPOINTS; x++) {
			float starting_err = MAX_ERR * pow(factor, float(x));
			rotamount *= factor;
			transamount *= factor;
			// Find a transformation that will produce
			// point-to-point distance of starting_err
			xform xf;
			float ratio;
			int it = 0;
			do {
				xf = xform::trans(transamount * transdir) *
				     xform::rot(rotamount, rotaxis);
				float actual_err = err(mesh2, xf);
				ratio = starting_err / actual_err;
				rotamount *= ratio;
				transamount *= ratio;
				it++;
			} while (it < 20 && (ratio < 0.9999f || ratio > 1.0001f));
			xf = xform::trans(transamount * transdir) *
			     xform::rot(rotamount, rotaxis);

			// Now perform an ICP iteration
			float cdfincr = 1.0f / DESIRED_PAIRS;
			float maxdist = M_SQRT2f;
			//float maxdist = 10.0f * starting_err;
			float rejection_thresh_mult = do_rejection ? 
				REJECTION_THRESH_MULT : 1000.0f;
			ICP_iter(mesh1, mesh2, xform(), xf, kd1, NULL,
				cdfincr, DESIRED_PAIRS, APPROX_EPS, maxdist,
				-1.0f, rejection_thresh_mult, variant, 0.0f);
				//0.0f, rejection_thresh_mult, variant, 0.0f);

			// Evaluate
			float actual_err = err(mesh2, xf);
			errs[x] += actual_err;
			//printf("%7.2g ", actual_err); fflush(stdout);
			printf("%7.2g ", errs[x] / (trial+1)); fflush(stdout);
		}
		printf("\n");
	}

	// Now write out the final results
	string name1 = replace_ext(argv[1], "");
	size_t slash = name1.find_last_of("/");
	if (slash != string::npos)
		name1.erase(0, slash + 1);

	string name2 = replace_ext(argv[2], "");
	slash = name2.find_last_of("/");
	if (slash != string::npos)
		name2.erase(0, slash + 1);

	string filename = name1 + "_" + name2 + "_" +
		to_string(variant) + ".txt";

	printf("Writing %s\n", filename.c_str());
	FILE *f = fopen(filename.c_str(), "w");

	for (int x = 0; x < NUM_DATAPOINTS; x++) {
		// Print out error before ICP iteration and
		// average error after
		fprintf(f, "%g %g\n", MAX_ERR * pow(factor, float(x)),
			errs[x] / ntrials);
	}

	fclose(f);
}

