%% tif图像保存 16 bit -> 16 bit
function TIf_write16bit(img, saveName)
[~, ~, z] = size(img);
for n = 1:z
    imwrite(any_to_16bit(img(:,:,n)), saveName, 'WriteMode', 'append',  'Compression','none');
end
