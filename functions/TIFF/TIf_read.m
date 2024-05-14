%% tif图片读入
function Image = TIf_read(dirpath)
Info=imfinfo(dirpath); 
tif='tif';
format=Info.Format;
if  (strcmp(format ,tif)==0)
    disp('载入的不是tif图像，请确认载入的数据');                %%确保载入的图像是tiff图像
end
Slice=size(Info,1);                                            %%获取图片z向帧数
Width=Info.Width;
Height=Info.Height;
Image=zeros(Height,Width,Slice);
for i=1:Slice
    Image(:,:,i)=imread(dirpath,i);          %%一层一层的读入图像
%     figure,imshow(uint8(Image(:,:,i)));
%     Image(:,:,i) = uint8(Image(:,:,i));
%     image_resize(:,:,i) = imresize(Image(:,:,i),[1024,200]);
%     image = uint8(image_resize(:,:,i));
%     imwrite(image,'myMultipageFile.tif','WriteMode','append');
end
