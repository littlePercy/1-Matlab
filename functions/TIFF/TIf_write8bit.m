%% tif图像保存 any bit -> 8 bit
function TIf_write(img, saveName)
[~, ~, z] = size(img);
for n = 1:z
    imwrite(any_to_8bit(img(:,:,n)), saveName, 'WriteMode', 'append',  'Compression','none');
end
