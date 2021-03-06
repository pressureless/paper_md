#pragma once
#include <Eigen/Core>
#include <Eigen/Dense>
#include <Eigen/Sparse>
#include <iostream>
#include <set>

struct eccentricity {
    int π_0;
    Eigen::VectorXd q;
    std::function<double(double, double)> m;
    double π_π β;
    Eigen::Matrix<double, 10, 1> π;
    double a;
    double π(
        const Eigen::Matrix<double, 2, 1> & x,
        const Eigen::Matrix<double, 2, 1> & x_0,
        const double & π,
        const double & π,
        const double & π_π )
    {
        Eigen::VectorXd π_1(2);
        π_1 << cos(π), sin(π);
        return exp(-pow((x - x_0).lpNorm<2>(), 2) / double((2 * pow(π, 2)))) * cos((2 * M_PI * π_π  * x).dot(π_1));    
    }
    double π(
        const double & π_π )
    {
        return m(log10(π_π ) - log10(π_π β), 0);    
    }
    double π(
        const double & π_π )
    {
        return exp(π[10-1] * π(π_π )) - 1;    
    }
    double Ξ¨(
        const double & π,
        const double & π_π )
    {
        return m(0, π[1-1] * pow(π(π_π ), 2) + π[2-1] * π(π_π ) + π[3-1] + (π[4-1] * pow(π(π_π ), 2) + π[5-1] * π(π_π ) + π[6-1]) * π(π_π ) * π + (π[7-1] * pow(π(π_π ), 2) + π[8-1] * π(π_π ) + π[9-1]) * π(π_π ) * pow(π, 2));    
    }
    double π΄(
        const double & π)
    {
        return log(64) * 2.3 / double((0.106 * (π + 2.3)));    
    }
    double π(
        const double & πΏ)
    {
        return 7.75 - 5.75 * (pow((πΏ * a / double(846)), 0.41) / double((pow((πΏ * a / double(846)), 0.41) + 2)));    
    }
    double π(
        const double & πΏ)
    {
        return M_PI * pow(π(πΏ), 2) / double(4) * πΏ;    
    }
    double π (
        const double & π,
        const double & π_π )
    {
        return π(π_π ) * (q[1-1] * pow(π, 2) + q[2-1] * π) + q[3-1];    
    }
    double hatΞ¨(
        const double & π,
        const double & π_π ,
        const double & πΏ)
    {
        return (π (π, π_π ) * (log10(π(πΏ) / double(π_0))) + 1) * Ξ¨(π, π_π );    
    }
    eccentricity(
        const std::function<double(double, double)> & m,
        const Eigen::Matrix<double, 10, 1> & π,
        const double & π_π β,
        const double & a)
    {
    
        this->m = m;
        this->π_π β = π_π β;
        this->π = π;
        this->a = a;
        // `$π_0$` = 1488
        π_0 = 1488;
        Eigen::VectorXd q_0(3);
        q_0 << 5.71 * pow(10, (-6)), -1.78 * pow(10, (-4)), 0.204;
        // q = (5.71 β 10^(-6), -1.78 β 10^(-4), 0.204)
        q = q_0;
    }
};

