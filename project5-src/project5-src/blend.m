function out = blend(img1, img2)
    mask = uint8(1 - im2bw(img1, 0));
    mask = cat(3, mask, mask, mask);
    out = img1 + mask .* img2;
end