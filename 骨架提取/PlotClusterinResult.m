function PlotClusterinResult(X, IDX)                
    k=max(IDX);                     %求矩阵IDX每一列的最大元素及其对应的索引                
 
    Colors=hsv(k);                  %颜色设置   
    Legends = {};                   %循环每一个簇类
    for i=0:k                                       
        Xi=X(IDX==i,:);                    
        if i~=0                                     
            Style = 'o';                            
            MarkerSize = 2;                         
            Color = Colors(i,:);                    
            Legends{end+1} = ['Cluster #' num2str(i)]; 
            plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',MarkerSize,'Color',Color,'MarkerFaceColor',Color);
%         else
%             Style = 'x';                            
%             MarkerSize = 2;                          
%             Color = [0 0 0];                        
%             if ~isempty(Xi)
%                 Legends{end+1} = 'Noise';           
%             end
        end
%         if ~isempty(Xi)
%             plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',MarkerSize,'Color',Color,'MarkerFaceColor',Color);
%         end
        hold on;
    end
    hold off;                                    
    axis equal;                                  
    grid on;                                     
    legend(Legends);
    legend('Location', 'NorthEastOutside');      
 
end                                              


