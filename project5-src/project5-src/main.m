key_frames_indices = [40, 190, 360, 520, 680];;
% for i = 1:744
%     fileName = ['frames3/f', num2str(i, '%04d'), '.jpg'];
%     fileName2 = ['frames3/r', num2str(i, '%04d'), '.jpg'];
%     img = imresize(imread(fileName), [360 480], 'bilinear');
%     imwrite(img, fileName2);
%     disp(i);
% end
% 
% images = cell(5);
% for	i = 1:5
%     idx = key_frames_indices(i);
%     fileName = ['frames3/r', num2str(idx, '%04d'), '.jpg'];
%     images{i} = imread(fileName);
% end

%%% PART 1 %%%

% H = eye(3, 3);
% T = maketform('projective', H');
% ref_img = imtransform(images{3}, T, 'XData',[-651 980],'YData',[-51 460]);
% [imt1, H2] = transform_image(images{2}, images{3}, 0, 0);
% 
% final_image = blend(ref_img, imt1);
% 
% f = figure(1);
% imshow(final_image);
% imwrite(final_image, 'result/part1-1.jpg');
% 
% coords = [300, 450, 450, 300;
%           100, 100, 250, 250;
%           1, 1, 1, 1;];
% coords2 = H2 * coords;
% for i = 1:4
%     coords2(:, i) = coords2(:, i) / coords2(3, i);
% end
% 
% figure(2);
% imshow(images{2});
% hold on
% plot([coords(1, 1), coords(1, 2)], [coords(2, 1), coords(2, 2)], 'Color', 'r');
% plot([coords(1, 2), coords(1, 3)], [coords(2, 2), coords(2, 3)], 'Color', 'r');
% plot([coords(1, 3), coords(1, 4)], [coords(2, 3), coords(2, 4)], 'Color', 'r');
% plot([coords(1, 4), coords(1, 1)], [coords(2, 4), coords(2, 1)], 'Color', 'r');
% 
% 
% f = figure(3);
% imshow(images{3});
% hold on
% plot([coords2(1, 1), coords2(1, 2)], [coords2(2, 1), coords2(2, 2)], 'Color', 'r');
% plot([coords2(1, 2), coords2(1, 3)], [coords2(2, 2), coords2(2, 3)], 'Color', 'r');
% plot([coords2(1, 3), coords2(1, 4)], [coords2(2, 3), coords2(2, 4)], 'Color', 'r');
% plot([coords2(1, 4), coords2(1, 1)], [coords2(2, 4), coords2(2, 1)], 'Color', 'r');

%%% PART 2 %%%

% H = eye(3, 3);
% T = maketform('projective', H');
% ref_img = imtransform(images{3}, T, 'XData',[-651 980],'YData',[-51 460]);
% [imt1, H2] = transform_image(images{2}, images{3}, 0, 0);
% [imt2, H3] = transform_image(images{4}, images{3}, 0, 0);
% [imt3, H4] = transform_image(images{1}, images{3}, images{2}, H2);
% [imt4, H5] = transform_image(images{5}, images{3}, images{4}, H3);
% 
% final_image = blend(imt3, imt1);
% final_image = blend(final_image, ref_img);
% final_image = blend(final_image, imt2);
% final_image = blend(final_image, imt4);
% 
% figure(1);
% imshow(final_image);
% imwrite(final_image, 'result/bells2-part2.jpg');

%%% PART 3 %%%

% H = create_video(key_frames_indices);
% dlmwrite('H3.txt', H);

% panorama = background_panorama();
% figure(1);
% imshow(panorama);
% imwrite(panorama, 'bells2-part4.png');
% 
% H_raw = load('H3.txt');
% H = cell(744, 1);
% for i = 1:744
%     H{i} = H_raw(3 * i - 2 : 3 * i, :);
% end
% 
% panorama = im2uint8(imread('bells2-part4.png'));
%  
% Tr = [1, 0, 651;
%      0, 1, 51;
%      0, 0, 1;];
% for i = 1:744
%     H{i} = H{i} / H{i}(3, 3);
%     H2 = Tr * H{i};
%     T = maketform('projective', H2');
%     flip = fliptform(T);
%     imt = imtransform(panorama, flip, 'XData',[0 479],'YData',[0 359]);
%     fileName = ['background4/b', num2str(i, '%04d'), '.png'];
%     imwrite(imt, fileName);
%     disp(i);
% end
% 
for i = 1:744
    fileName1 = ['frames3/r', num2str(i, '%04d'), '.jpg'];
    fileName2 = ['background4/b', num2str(i, '%04d'), '.png'];
    fileName3 = ['foreground3/f', num2str(i, '%04d'), '.jpg'];
    im1 = im2uint8(imread(fileName1));
    im2 = im2uint8(imread(fileName2));
    [imh, imw, dim] = size(im1);
    diff = imabsdiff(im1, im2);
    out = uint8(zeros(imh, imw, dim) + 127);
    for r = 1:imh
        for c = 1:imw
            max_diff = max(diff(r, c, 1), max(diff(r, c, 2), diff(r, c, 3)));
            if max_diff < 25
                continue;
            end
            for d = 1:dim
                out(r, c, d) = im1(r, c, d);
            end
        end
    end

    imwrite(out, fileName3);
    disp(i);
end
