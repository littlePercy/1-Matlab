function deletaImg = bifur_delete(SkelImg,bifurPoints)
deletaImg = SkelImg;
for i = 1:size(bifurPoints,1)
    deletaImg(bifurPoints(i,1),bifurPoints(i,2))=0;
end
