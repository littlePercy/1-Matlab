function point_list = remainRegion(Img, conNum)
% ===============================================
% 2022/7/14 yuShuai                                    
% 功能：获取连通域标记图像中的一个区域  
% 输入：连通域标记图像Img以及label
% 输出：只保留选取的label区域的二值化输出
% ===============================================
lis = [];
[row,col] = size(Img);
temp = zeros(row,col);
for i=1:conNum
    num = length(find(Img==i));
    lis = [lis; [i,num]];
end
[maxValue, maxIndex] = max(lis(:,2));
point_list = [];
for n = 1:conNum % 遍历每个连通域求解
    if n~=maxIndex
        for i=1:row
            for j=1:col
                if Img(i,j)==n
                    temp(i,j)=255;
                else
                    temp(i,j)=0;
                end
            end
        end
        selectedImg = imbinarize(temp);
        STATS = regionprops(selectedImg,'Centroid');
        center = STATS.Centroid;                                           % √√ 质心坐标（图像坐标系）
        point_list = [point_list;center];
    end
end











