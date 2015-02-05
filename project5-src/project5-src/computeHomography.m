function H = computeHomography(x1, y1, x2, y2) 

hom1=[x1;y1;ones(size(x1))];
hom2=[x2;y2;ones(size(x2))];

A = [] ;
for i = 1:length(x1)
    A = cat(1, A, kron(hom1(:,i)', vl_hat(hom2(:,i)))) ;
end

[U,S,V] = svd(A) ;
H = reshape(V(:,9),3,3) ;

  