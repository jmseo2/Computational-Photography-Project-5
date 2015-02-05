function H = create_video(key_frames_indices)
    num_key_frames = size(key_frames_indices, 2);
    key_frames = cell(num_key_frames, 1);
    for idx = 1:num_key_frames
        i = key_frames_indices(idx);
        fileName = ['frames3/r', num2str(i, '%04d'), '.jpg'];
        key_frames{idx} = im2double(imread(fileName));
    end
    
    H = cell(744, 1);
    [f1, H1] = transform_image(key_frames{3}, key_frames{3}, 0, 0); 
    [f2, H2] = transform_image(key_frames{2}, key_frames{3}, 0, 0);
    [f3, H3] = transform_image(key_frames{4}, key_frames{3}, 0, 0);
    [f4, H4] = transform_image(key_frames{1}, key_frames{3}, key_frames{2}, H2);
    [f5, H5] = transform_image(key_frames{5}, key_frames{3}, key_frames{4}, H3);
    H_key = {H4, H2, H1, H3, H5};
    
    for i = 1:744
        in_fileName = ['frames3/r', num2str(i, '%04d'), '.jpg'];
        frame = im2double(imread(in_fileName));
        
        key_idx = find_closest_key_frame(i, key_frames_indices);
        if key_idx == 3
            [out_frame, H{i}] = transform_image(frame, key_frames{3}, 0, 0); 
        else
            [out_frame, H{i}] = transform_image(frame, key_frames{3}, key_frames{key_idx}, H_key{key_idx});
        end
        
        %out_mask = im2bw(out_frame, 0);
        out_fileName = ['aligned_frames3/a', num2str(i, '%04d'), '.jpg'];
        %out_fileName2 = ['masks2/m', num2str(i, '%04d'), '.txt'];
        imwrite(out_frame, out_fileName);
        %dlmwrite(out_fileName2, out_mask);
        disp(i);
    end
end

function key_idx = find_closest_key_frame(frame_num, key_frames)
    if frame_num < 360
        for i = 3:-1:1
            if key_frames(i) > frame_num
                key_idx = i;
            end
        end
    else
        for i = 3:5
            if key_frames(i) <= frame_num
                key_idx = i;
            end
        end
    end
end