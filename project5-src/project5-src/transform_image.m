function [out, H] = transform_image(img, ref_img, mid_img, H2)
    if mid_img == 0
        H = auto_homography(img, ref_img);
    else
        H1 = auto_homography(img, mid_img);
        H = H1 * H2;
    end
    H = H / H(3, 3);
    T = maketform('projective', H');
    out = imtransform(img, T, 'XData',[-651 980],'YData',[-51 460]);
end