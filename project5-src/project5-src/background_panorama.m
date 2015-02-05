function out = background_panorama()
    h = zeros(512, 1632, 3, 256);
    freq = zeros(512, 1632, 3);
    out = uint8(zeros(512, 1632, 3));
    for i = 1:744
        fileName = ['aligned_frames3/a', num2str(i, '%04d'), '.jpg'];
        frame = im2uint8(imread(fileName));
        for r = 1:512
            for c = 1:1632
                if frame(r, c, 1) == 0 && frame(r, c, 2) == 0 && frame(r, c, 3) == 0
                    continue;
                end
                for d = 1:3
                   pixel = frame(r, c, d);
                   h(r, c, d, pixel + 1) = h(r, c, d, pixel + 1) + 1; 
                   freq(r, c, d) = freq(r, c, d) + 1;
                end
            end
        end
        disp(i);
    end
    count = 1;
    for r = 1:512
        for c = 1:1632
            for d = 1:3
                s = freq(r, c, d);
                cumsum = 0;
                for p = 1:256
                    cumsum = cumsum + h(r, c, d, p);
                    if cumsum >= s / 2
                        out(r, c, d) = p - 1;
                        break;
                    end
                end
            end
        end
        count = count + 1;
        disp(count);
    end
%     fileName = ['aligned_frames/a', num2str(1, '%04d'), '.jpg'];
%     out = im2double(imread(fileName));
%     fileName = ['masks/m', num2str(1, '%04d'), '.txt'];
%     overlap_counts = imerode(load(fileName), ones(3, 3));
%     
%     [imh, imw, dim] = size(out);
% 
%     for	i = 2:900
%         fileName = ['aligned_frames/a', num2str(i, '%04d'), '.jpg'];
%         img = im2double(imread(fileName));
%         fileName = ['masks/m', num2str(i, '%04d'), '.txt'];
%         mask = load(fileName);
%         overlap_counts = overlap_counts + imerode(mask, ones(3, 3));
%         out = out + img;
%         disp(i);
%     end
%     
%     for i = 1:imh
%         for j = 1:imw
%             if overlap_counts(i, j) == 0
%                 continue;
%             end
%             for d = 1:dim
%                 out(i, j, d) = out(i, j, d) / overlap_counts(i, j);
%             end
%         end
%     end
%     
%     fileName = ['aligned_frames/a', num2str(1, '%04d'), '.jpg'];
%     img = im2double(imread(fileName));
%     best = img;
%     for	i = 2:900
%         fileName = ['aligned_frames/a', num2str(i, '%04d'), '.jpg'];
%         img = im2double(imread(fileName));
%         
%         diff1 = sum((out - best).^2, 3);
%         diff2 = sum((out - img).^2, 3);
%         mask = im2bw(zeros(size(diff1)), 0);
%         
%         mask(diff2 < diff1) = 1;
%         
%         best = cat(3, 1 - mask, 1 - mask, 1 - mask) .* best + cat(3, mask, mask, mask) .* img;
%         disp(i);
%     end
%     out = best;
end
