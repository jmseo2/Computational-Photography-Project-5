function H=auto_homography(Ia,Ib)
% Computes a homography that maps points from Ia to Ib
%
% Input: Ia and Ib are images
% Output: H is the homography
%
% Note: to use H in maketform, use maketform('projective', H')

[fa,da] = vl_sift(im2single(rgb2gray(Ia))) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib))) ;
matches = vl_ubcmatch(da,db) ;

numMatches = size(matches,2) ;

Xa = fa(1:2,matches(1,:)) ; Xa(3,:) = 1 ;
Xb = fb(1:2,matches(2,:)) ; Xb(3,:) = 1 ;


%% ransac
clear H score ok ;

for t = 1:1000
    % estimate homograpyh
    subset = vl_colsubset(1:numMatches, 4) ;
    x1=fa(1,matches(1,subset));
    y1=fa(2,matches(1,subset));
    x2=fb(1,matches(2,subset));
    y2=fb(2,matches(2,subset));
    H{t} = computeHomography(x1, y1, x2, y2);
    
    % score homography
    Xb_ = H{t} * Xa ;
    du = Xb_(1,:)./Xb_(3,:) - Xb(1,:)./Xb(3,:) ;
    dv = Xb_(2,:)./Xb_(3,:) - Xb(2,:)./Xb(3,:) ;
    ok{t} = sqrt(du.*du + dv.*dv) < 1.5;
    score(t) = sum(ok{t}) ;
            
end

[~, best] = max(score) ;

H = H{best};
ok = ok{best};

% re-estimate homography based on inliers
if exist('fminsearch') == 2
	H = H / H(3,3) ;
	opts = optimset('Display', 'none', 'TolFun', 1e-8, 'TolX', 1e-8) ;
	H(1:8) = fminsearch(@(H) residual(H,Xa,Xb,ok), H(1:8)', opts) ;
else
	warning('Refinement disabled as fminsearch was not found.') ;
end
% H = computeHomography(Xa(1, ok{best}), Xa(2, ok{best}), Xb(1, ok{best}), Xb(2, ok{best}));
    
% re-estimate homography based on inliers
% H = computeHomography(Xa(1, ok{best}), Xa(2, ok{best}), Xb(1, ok{best}), Xb(2, ok{best}));

% comparing original vs re-estimated homography
% Xb_ = H{best} * Xa ;
% du = Xb_(1,:)./Xb_(3,:) - Xb(1,:)./Xb(3,:) ;
% dv = Xb_(2,:)./Xb_(3,:) - Xb(2,:)./Xb(3,:) ;
% disp(num2str([sum(ok{best}) mean(sqrt(du(ok{best}).*du(ok{best})+dv(ok{best}).*dv(ok{best})))]))

% Xb_ = H * Xa ;
% du = Xb_(1,:)./Xb_(3,:) - Xb(1,:)./Xb(3,:) ;
% dv = Xb_(2,:)./Xb_(3,:) - Xb(2,:)./Xb(3,:) ;
% ok = sqrt(du.*du + dv.*dv) < 1.5;
% disp(num2str([sum(ok) mean(sqrt(du(ok).*du(ok)+dv(ok).*dv(ok)))]))

end

function err = residual(H,X1,X2,ok)
    u = H(1) * X1(1,ok) + H(4) * X1(2,ok) + H(7) ;
    v = H(2) * X1(1,ok) + H(5) * X1(2,ok) + H(8) ;
    d = H(3) * X1(1,ok) + H(6) * X1(2,ok) + 1 ;
    du = X2(1,ok) - u ./ d ;
    dv = X2(2,ok) - v ./ d ;
    err = sum(du.*du + dv.*dv) ;
end
