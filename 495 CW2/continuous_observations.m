clear all;
clc;

%%%%%%%%%%%%%%%%%%%
% DATA GENERATION %
%%%%%%%%%%%%%%%%%%%
N  = 2000;         % number of sequences
T  = 100;        % length of the sequence

% Initial Probability at time 1
pi = [0.3; 0.7]; 

% Transition probability matrix for data generation
A  = [0.4 0.6 ; 0.4 0.6 ];       

% One Dimensional Gaussians 
E.mu    =[0.1 0.5]; %%the means of each of the Gaussians
E.sigma2=[0.4 0.8]; %%the variances

% Y is the set of generated observations 
% S is the set of ground truth sequence of latent vectors 
[ Y, S ] = HmmGenerateData(N, T, pi, A, E, 'normal'); 


%%%%%%%%%%%%%%%%
% EM ALGORITHM %
%%%%%%%%%%%%%%%%
% Initializing parameters
pi = [0.4; 0.6]; 
A  = [0.2 0.8 ; 0.7 0.3 ];       

% One Dimensional Gaussians 
E.mu    =[0.7 0.6]; %%the means of each of the Gaussians
E.sigma2=[0.5 0.4]; %%the variances

% Running EM Algorithm

mu = E.mu;
sigma2=E.sigma2;
for i = 1:1000
    
    [post_latent, post_transit] = HMMExpectationContinuous (Y,N,T,pi,A,mu,sigma2);  
    [pi, A, mu, sigma2] = HMMMaximizationContinuous(Y,N,T, mu, sigma2,post_latent, post_transit);

end

decode = HMMViterbiContinuous(Y,N,T,pi, A, mu, sigma2);

accuracy = sum(sum(decode==S))/(N*T);


pi
A
mu
sigma2