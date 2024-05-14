tiffStack_img = TIf_read("\\192.168.0.138\csr共享网盘2\03 客户临时区（每周五18时30分清空）\to郁帅\z4 分割最终结果\7-525.tif");
save_path = '7-560-result';
if exist(save_path)==0   %判断文件夹是否存在
    mkdir(save_path);    %不存在时候，创建文件夹
end
for nn = 1:size(tiffStack_img ,3)
    binary_image = tiffStack_img(:,:,nn);
    % 确定移动的像素值
    shift_right = 10;
    shift_down = 2;
    % 创建一个新的图像，初始值为0
    new_binary_image = zeros(size(binary_image), 'uint8');
    % 对每个像素进行移动
    for i = 1:size(binary_image, 1)
        for j = 1:size(binary_image, 2)
            if binary_image(i, j) == 255  % 如果像素值为255，则移动
                new_i = min(i + shift_down, size(binary_image, 1)); % 向下移动
                new_j = min(j + shift_right, size(binary_image, 2)); % 向右移动
                new_binary_image(new_i, new_j) = 255;
            end
        end
    end
    frame = sprintf('%04d', nn);
    imwrite(new_binary_image,  [save_path,'/', frame,'.png']);
end
