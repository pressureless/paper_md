# python  process.py  --la_path=/path/to/linear_algebra
import json
import os
from os import listdir
from pathlib import Path
import shutil
import subprocess
import argparse
import urllib

parser = argparse.ArgumentParser()
parser.add_argument('--gallery_path', default='./lektor_proj')
parser.add_argument('--paper_path', default='./papers')
parser.add_argument('--la_path', default=r'/Users/pressure/Downloads/linear_algebra') 
FLAGS = parser.parse_args()

gallery_path = FLAGS.gallery_path
la_path = FLAGS.la_path
paper_path = FLAGS.paper_path
PATH = os.environ['PATH']
PATH = ':'.join( [ la_path, PATH ] )

with open('./info.json') as f:
	data = json.load(f) 
	# create gallery_res direcotry
	gallery_res_dir = Path("{}/assets/static/gallery_res".format(gallery_path))
	if gallery_res_dir.exists():
		shutil.rmtree(gallery_res_dir) 
	gallery_res_dir.mkdir()
	shutil.copytree("{}/extras/heartdown-resource".format(la_path),
	 "{}/heartdown-resource".format(gallery_res_dir))
	# create gallery directory
	gallery_dir = Path("{}/content/gallery".format(gallery_path))
	if gallery_dir.exists():
		shutil.copy(gallery_dir / 'contents.lr', Path("{}/contents.lr".format(gallery_path)))
		shutil.rmtree(gallery_dir)
	gallery_dir.mkdir()
	shutil.move("{}/contents.lr".format(gallery_path), str(gallery_dir))
	# for item in data['gallery']:
	for index in range(len(data['gallery'])):
		item = data['gallery'][index] 
		markdown_f_name = "{}.md".format(item['markdown'])
		cpp_f_name = "lib.h"
		python_f_name = "{}.py".format('lib')
		matlab_f_name = "{}.m".format('lib')
		# pdf_f_name = "{}.pdf".format(item['la_file'])
		# tex_f_name = "{}.tex".format(item['la_file'])
		# # resource
		item_res_dir = gallery_res_dir / item['dir']
		item_res_dir.mkdir()

		# shutil.copy(Path("{}/desc_figure/{}".format(gallery_path, item['desc_figure'])), item_res_dir)
		# shutil.copy(Path("{}/thumb_figure/{}".format(gallery_path, item['thumb_figure'])), item_res_dir)

		ret = subprocess.run(["python", "{}/app.py".format(la_path), 
			"--resource_dir", '..', 
			"--paper", Path("{}/{}/{}".format(paper_path, item['dir'], 
				markdown_f_name))], env={"PATH":PATH})
		# ret = subprocess.run(["xelatex", "-interaction=nonstopmode", Path("{}/la_file/{}".format(gallery_path, tex_f_name))], capture_output=True, env={"PATH":PATH})
		
		# shutil.copy(Path("{}/la_file/{}".format(gallery_path, la_f_name)), item_res_dir/la_f_name)
		shutil.copy(Path("{}/{}/{}".format(paper_path, item['dir'], markdown_f_name)), 
			item_res_dir/"{}.txt".format(item['markdown']))

		code_res_dir = gallery_res_dir / "{}/{}".format(item['dir'], 'code_dir')
		code_res_dir.mkdir()
		shutil.copy(Path("{}/{}/output_code/{}".format(paper_path, item['dir'], cpp_f_name)), 
			code_res_dir/cpp_f_name)
		shutil.copy(Path("{}/{}/output_code/{}".format(paper_path, item['dir'], python_f_name)), 
			code_res_dir/python_f_name)
		shutil.copy(Path("{}/{}/output_code/{}".format(paper_path, item['dir'], matlab_f_name)), 
			code_res_dir/matlab_f_name)
		# Copy ./output_code to ./
		shutil.copy(Path("{}/{}/output_code/{}".format(paper_path, item['dir'], cpp_f_name)), 
			Path("{}/{}/{}".format(paper_path, item['dir'], cpp_f_name)))
		shutil.copy(Path("{}/{}/output_code/{}".format(paper_path, item['dir'], python_f_name)), 
			Path("{}/{}/{}".format(paper_path, item['dir'], python_f_name)))
		shutil.copy(Path("{}/{}/output_code/{}".format(paper_path, item['dir'], matlab_f_name)), 
			Path("{}/{}/{}".format(paper_path, item['dir'], matlab_f_name)))

		output_html_file = "{}.html".format(item['markdown'])
		shutil.copy(Path("{}/{}/{}".format(paper_path, item['dir'], output_html_file)), 
			item_res_dir/output_html_file)
		# copy origin.png and vis.png
		shutil.copy(Path("{}/{}/{}".format(paper_path, item['dir'], "origin.png")), 
			item_res_dir/"origin.png")
		shutil.copy(Path("{}/{}/{}".format(paper_path, item['dir'], "vis.png")), 
			item_res_dir/"vis.png")
		if item['original'] != '':
			shutil.copy(Path("{}/{}/{}".format(paper_path, item['dir'], item['original'])), 
			item_res_dir/item['original'])
		if os.path.exists(Path("{}/{}/{}".format(paper_path, item['dir'], item['img_dir']))):
			shutil.copytree(Path("{}/{}/{}".format(paper_path, item['dir'], item['img_dir'])), 
				item_res_dir/item['img_dir'])

		if item['has_code']:
			shutil.copytree(Path("{}/{}/{}".format(paper_path, item['dir'], "original_src")), 
			item_res_dir/"original_src")
			shutil.copytree(Path("{}/{}/{}".format(paper_path, item['dir'], "replaced_src")), 
			item_res_dir/"replaced_src")
		# shutil.copy(Path("{}/la_file/{}".format(gallery_path, python_f_name)), item_res_dir/python_f_name)
		# shutil.copy(Path("{}/la_file/{}".format(gallery_path, matlab_f_name)), item_res_dir/matlab_f_name)
		# shutil.copy(Path("{}/{}".format(gallery_path, pdf_f_name)), item_res_dir/pdf_f_name)
		# shutil.copy(Path("{}/la_file/{}".format(gallery_path, tex_f_name)), item_res_dir/tex_f_name)

		# content
		item_dir = gallery_dir / item['dir']
		item_dir.mkdir()
		item_file = item_dir / 'contents.lr'

		with open(item_file, 'w') as item_f:
			item_f.write("title: {}\n".format(item['title']))
			item_f.write("---\n")
			item_f.write("comefrom: {}\n".format(item['comefrom']))
			item_f.write("---\n")
			item_f.write("authors: {}\n".format(item['authors']))
			item_f.write("---\n")
			item_f.write("original_file: /static/gallery_res/{}/{}\n".format(item['dir'], urllib.parse.quote(item['original'])))
			item_f.write("---\n")
			item_f.write("markdown_file: /static/gallery_res/{}/{}.txt\n".format(item['dir'], item['markdown']))
			item_f.write("---\n")
			item_f.write("whole_paper:{}\n".format(item['whole_paper']))
			item_f.write("---\n") 
			item_f.write("has_code:{}\n".format(item['has_code']))
			item_f.write("---\n") 
			item_f.write("origin_img: /static/gallery_res/{}/origin.png\n".format(item['dir']))
			item_f.write("---\n") 
			item_f.write("vis_img: /static/gallery_res/{}/vis.png\n".format(item['dir']))
			item_f.write("---\n") 
			item_f.write("code_dir: /static/gallery_res/{}/code_dir\n".format(item['dir']))
			item_f.write("---\n") 
			if not item['whole_paper']:
				item_f.write("section:{}\n".format(item['section']))
				item_f.write("---\n")  
			if item['has_code']:
				item_f.write("link:{}\n".format(item['link']))
				item_f.write("---\n")  
				#
				item_f.write("original_src: /static/gallery_res/{}/original_src\n".format(item['dir']))
				item_f.write("---\n") 
				item_f.write("replaced_src: /static/gallery_res/{}/replaced_src\n".format(item['dir']))
				item_f.write("---\n") 
		
			# with open(item_res_dir/cpp_f_name, 'r') as cpp_f:
			# 	cpp_content = cpp_f.read()
			# item_f.write("cpp_code: {}\n".format(cpp_content))
			item_f.write("cpp_code: /static/gallery_res/{}/{}\n".format(item['dir'], cpp_f_name))
			item_f.write("---\n")


			item_f.write("output_file: /static/gallery_res/{}/{}.html\n".format(item['dir'], item['markdown']))
			item_f.write("---\n")

			# with open(item_res_dir/python_f_name, 'r') as py_f:
			# 	py_content = py_f.read()
			item_f.write("python_code: /static/gallery_res/{}/{}\n".format(item['dir'], python_f_name))
			item_f.write("---\n")

			# with open(item_res_dir/matlab_f_name, 'r') as mat_f:
			# 	matlab_content = mat_f.read()
			item_f.write("matlab_code: /static/gallery_res/{}/{}\n".format(item['dir'], matlab_f_name))
			item_f.write("---\n") 

			# with open(item_res_dir/tex_f_name, 'r') as tex_f:
			# 	tex_content = tex_f.read()
			# item_f.write("tex_code: {}\n".format(tex_content))
			# item_f.write("---\n")

			# with open(item_res_dir/la_f_name, 'r') as la_f:
			# 	la_content = la_f.read()
			# item_f.write("la_code: {}\n".format(la_content))
			# item_f.write("---\n")
 
			item_f.close() 
