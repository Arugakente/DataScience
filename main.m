#Via le nombre de lien
n = ones(15,1);

#Matrice bidon (en attendant l'automatisation/google)
M = zeros(15); %A remplacer
%A voir : valeur de 1 si plusieurs fois lien vers même page, ou valeur de nb de fois le lien

disp(M);

#{     
for i=1:size(M)(1)
  for j=1:size(M)(1) 
    M(j,i) = rand();
  endfor
endfor
#}

for i=1:size(M)(1)
  somme = sum(M(:,i));
  
  for j=1:size(M)(2)
    M(j,i) = M(j,i)/somme;
  endfor
  
  disp(sum(M(:,i)));
endfor



T = 10;

x = zeros(size(M)(1), T);
x(:,1) = n; #x initial

for i=1:T
    n = M*n;
    x(:,i+1) = n;
endfor

figure(1);
plot(0:T, x(1,:));
hold on;

for i=1:size(M)(1)
  plot(0:T, x(i,:));
endfor