img_path = 'C:\Users\m1360\Desktop\去噪实验结果\QT\QT3\test_imgs';
save_path1 = 'D:\Matlab-code\denoise\RemoveBG\addnoise\QT3\train_imgs_addnoise';
save_path2 = 'D:\Matlab-code\denoise\RemoveBG\addnoise\QT3\test_imgs_addnoise';
if exist(save_path1)==0    % 判断文件夹是否存在
    mkdir(save_path1);     % 不存在时候，创建文件夹
end
if exist(save_path2)==0    % 判断文件夹是否存在
    mkdir(save_path2);     % 不存在时候，创建文件夹
end
img_dir = dir(img_path);
save_path = save_path2;
%%
for i = 3:32
    img_name = img_dir(i).name;
    image = [img_path, '/', img_name];
    save_name = [save_path, '/', img_name(1:end-4), '_gaussian_15.tif'];
    img = TIf_read(image);
    [~, ~, z] = size(img);
    for n = 1:z
        image_z = any_to_16bit(img(:,:,n));
        J_gaussian_15 = imnoise(image_z, 'gaussian', 0, (15/255)^2) ;
        imwrite(J_gaussian_15, save_name, 'WriteMode', 'append',  'Compression', 'none');
    end
end
%%
for i = 33:62
    img_name = img_dir(i).name;
    image = [img_path, '/', img_name];
    save_name = [save_path, '/', img_name(1:end-4), '_gaussian_30.tif'];
    img = TIf_read(image);
    [~, ~, z] = size(img);
    for n = 1:z
        image_z = any_to_16bit(img(:,:,n));
        J_gaussian_30 = imnoise(image_z, 'gaussian', 0, (30/255)^2) ;
        imwrite(J_gaussian_30, save_name, 'WriteMode', 'append',  'Compression', 'none');
    end
end
%%
for i = 63:92
    img_name = img_dir(i).name;
    image = [img_path, '/', img_name];
    save_name = [save_path, '/', img_name(1:end-4), '_gaussian_45.tif'];
    img = TIf_read(image);
    [~, ~, z] = size(img);
    for n = 1:z
        image_z = any_to_16bit(img(:,:,n));
        J_gaussian_45 = imnoise(image_z, 'gaussian', 0, (45/255)^2) ;
        imwrite(J_gaussian_45, save_name, 'WriteMode', 'append',  'Compression', 'none');
    end
end
%%
for i = 93:122
    img_name = img_dir(i).name;
    image = [img_path, '/', img_name];
    save_name = [save_path, '/', img_name(1:end-4), '_poisson.tif'];
    img = TIf_read(image);
    [~, ~, z] = size(img);
    for n = 1:z
        image_z = any_to_16bit(img(:,:,n));
        J_poisson = imnoise(image_z, 'poisson') ;
        imwrite(J_poisson, save_name, 'WriteMode', 'append',  'Compression', 'none');
    end
end
