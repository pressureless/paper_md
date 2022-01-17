#pragma once
#include <Eigen/Core>
#include <Eigen/Dense>
#include <Eigen/Sparse>
#include <iostream>
#include <set>

struct soft {
    double F_S;

    soft(
        const std::vector<std::function<double(Eigen::Matrix<double, 3, 1>)>> & D,
        const std::vector<Eigen::Matrix<double, 3, 1>> & boldsymbolu,
        const double & sigma,
        const std::vector<double> & a)
    {
        const long dim_0 = a.size();
        assert( D.size() == dim_0 );
        assert( boldsymbolu.size() == dim_0 );
        double sum_0 = 0;
        for(int i=1; i<=a.size(); i++){
            sum_0 += a.at(i-1) * D.at(i-1)(boldsymbolu.at(i-1));
        }
        double sum_1 = 0;
        for(int i=1; i<=a.size(); i++){
            sum_1 += a.at(i-1);
        }
        double sum_2 = 0;
        for(int i=1; i<=a.size(); i++){
            sum_2 += pow(a.at(i-1), 2);
        }
        // `$F_S$` = sum_i a_i D_i(`$\boldsymbol{u}$`_i) + σ((sum_i a_i)/(sum_i a_i^2) - 1)
        F_S = sum_0 + sigma * ((sum_1) / double((sum_2)) - 1);
    }
};

