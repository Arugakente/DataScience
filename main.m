#Via le nombre de lien
n = [0.43; 0.76; 0.10; 0.61; 0.21;  0.82; 0.34; 0.14; 0.62; 0.06;  0.42; 0.27; 0.72; 0.38; 0.55];

#Matrice bidon (en attendant l'automatisation/google)
M = zeros(15);

disp(M);
     
for i=1:size(M)(1)
  for j=1:size(M)(1) 
    M(j,i) = rand();
  endfor
endfor


for i=1:size(M)(1)
  somme = sum(M(:,i));
  
  for j=1:size(M)(2)
    M(j,i) = M(j,i)/somme;
  endfor
  
  disp(sum(M(:,i)));
endfor



T = 20;

x = zeros(size(M)(1), T);
x(:,1) = n; #x initial

for i=2:T
    n = M*n;
    x(:,i) = n;
endfor

figure(1);
plot(1:T, x(1,:));
hold on;

for i=2:size(M)(1)
  plot(1:T, x(i,:));
endfor