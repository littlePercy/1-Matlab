function output = any_to_8bit(img)
%ANY_TO_8BIT 此处显示有关此函数的摘要
%   此处显示详细说明
xmax = max(max(img));
xmin = min(min(img));
output = uint8(255*(img-xmin)/(xmax-xmin)); %归一化
end

