%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%          Matrix method for Poisson Equation         %%%%
%%%     u_{xx} + u_{yy} = f(x, y), 0 < x < 1, 0 < y < 1  %%%%
%%%              u(x, y) = 0 on boundary,                %%%%  
%%%  Exact soln: u(x, y) = sin(pi*x)*sin(pi*y)           %%%%
%%%        Here f(x, y) = -2*pi^2*sin(pi*x)*sin(pi*y);   %%%%
%%%        Course: MATH F422, Dr. P. Dhanumjaya          %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
close all;

%Initializing the domain

a = 0; 
b = 1; 
c = 0; 
d = 1;

%Setting up the resolution in x and y axes
M = 100; 
N = 100;

format long;

%Setting step size
hx = (b-a)/M; 
hx1 = hx*hx; 

x = zeros(M-1,1);

for i=1:M-1,
  x(i) = i*hx;
end

hy = (d-c)/N; 

hy1 = hy*hy; 

y=zeros(N-1,1);

for i=1:N-1,
  y(i) = i*hy;
end

%Finding the total number of linear elements
M1 = (N-1)*(M-1); 

A = sparse(M1,M1); 

F = zeros(M1,1);

for j = 1:N-1
  for i=1:M-1
    k = i + (j-1)*(M-1); %Linearizing the 2D domain
    
    F(k) = fpoisson(x(i),y(j));
    
    A(k,k) = -2/hx1 -2/hy1;
    
    if i == 1
        A(k,k+1) = 1/hx1;
    else
       if i==M-1
         A(k,k-1) = 1/hx1;
       else
        A(k,k-1) = 1/hx1;
        A(k,k+1) = 1/hx1;
       end
    end

%-- y direction --------------

    if j == 1
        A(k,k+M-1) = 1/hy1;
    else
       if j==N-1
         A(k,k-(M-1)) = 1/hy1;
       else
          A(k,k-(M-1)) = 1/hy1;
          A(k,k+M-1) = 1/hy1;
       end
     end

  end
end
tic
U = A\F;
toc
%--- Transform back to (i,j) form to plot the solution ---

j = 1;
for k=1:M1
  i = k - (j-1)*(M-1) ;
  Uapp(i,j) = U(k);
  Uex(i,j) = uexact(x(i),y(j));
  j = fix(k/(M-1)) + 1;
end

% Analyze and Visualize the result.

e = max( max( abs(Uapp-Uex)))        % The maximum error
figure;
subplot(1,2,1);
surf(x,y,Uapp); 
title('The Approximate solution plot'); 
xlabel('x'); 
ylabel('y');

subplot(1,2,2);
surf(x,y,Uex); 
title('The Exact solution plot'); 
xlabel('x');
ylabel('y');
