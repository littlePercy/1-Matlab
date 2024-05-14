function selectedImg = selecRegion(Img,label)
% ===============================================
% 2022/7/14 yuShuai                                    
% 功能：获取连通域标记图像中的一个区域  
% 输入：连通域标记图像Img以及label
% 输出：只保留选取的label区域的二值化输出
% ===============================================
[row,col] = size(Img);
temp = zeros(row,col);
[rr, cc] = find(Img==label);
for kk = 1:length(rr)
    temp(rr(kk), cc(kk))=255;
end
% for i=1:row
%     for j=1:col
%         if Img(i,j)==label
%             temp(i,j)=255;
%         else
%             temp(i,j)=0;
%         end
%     end   
% end
selectedImg = imbinarize(temp);
