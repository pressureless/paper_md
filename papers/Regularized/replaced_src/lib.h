#pragma once
#include <Eigen/Core>
#include <Eigen/Dense>
#include <Eigen/Sparse>
#include <iostream>
#include <set>

struct Regularized {
    int placeholder;
    double r_ε;
    double a;
    double b;
    double ε;
    Eigen::Matrix<double, 3, 1> f;
    Eigen::Matrix<double, 3, 3> F;
    double s;
    double row_ε(
        const Eigen::Matrix<double, 3, 1> & r)
    {
        return (15 * r_ε / double(8) + 1 / double(pow(r_ε, 3)));    
    }
    Eigen::Matrix<double, 3, 1> u_ε(
        const Eigen::Matrix<double, 3, 1> & r)
    {
        return ((a - b) / double(r_ε) * Eigen::MatrixXd::Identity(3, 3) + b / double(pow(r_ε, 3)) * r * r.transpose() + a / double(2) * pow(ε, 2) / double(pow(r_ε, 3)) * Eigen::MatrixXd::Identity(3, 3)) * f;    
    }
    Eigen::Matrix<double, 3, 1> t_ε(
        const Eigen::Matrix<double, 3, 1> & r)
    {
        return -a * (1 / double(pow(r_ε, 3)) + 3 * pow(ε, 2) / double((2 * pow(r_ε, 5)))) * F * r;    
    }
    Eigen::Matrix<double, 3, 1> s_ε(
        const Eigen::Matrix<double, 3, 1> & r)
    {
        return (2 * b - a) * (1 / double(pow(r_ε, 3)) + 3 * pow(ε, 2) / double((2 * pow(r_ε, 5)))) * (s * r);    
    }
    Eigen::Matrix<double, 3, 1> p_ε(
        const Eigen::Matrix<double, 3, 1> & r)
    {
        return (2 * b - a) / double(pow(r_ε, 3)) * F * r - 3 / double((2 * pow(r_ε, 5))) * (2 * b * ((double)(r.transpose() * F * r)) * Eigen::MatrixXd::Identity(3, 3) + a * pow(ε, 2) * F) * r;    
    }
    Regularized(
        const Eigen::Matrix<double, 3, 1> & f,
        const double & s,
        const Eigen::Matrix<double, 3, 3> & F,
        const double & r_ε,
        const double & a,
        const double & b,
        const double & ε)
    {
        this->r_ε = r_ε;
        this->a = a;
        this->b = b;
        this->ε = ε;
        this->f = f;
        this->F = F;
        this->s = s;
        // placeholder = 1
        placeholder = 1;
    }
};

