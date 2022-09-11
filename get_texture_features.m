function Texture = get_texture_features(I,label,N,G,Offset)
Texture=[];
for i=1:3
image=I(:,:,i);
 texture =[]; 
 for label_Num= 1:N  
     
    Region=label==label_Num;
    Region=uint8(Region);
    R = image.*Region;
     glcm=graycomatrixjiao(R, 'NumLevels', 8, 'G',[G(1),G(2)],'Offset', [Offset(1),Offset(2)]);
     stats = graycoprops( glcm, 'Contrast Energy Homogeneity ' );   
     texture_v = [stats.Contrast,stats.Energy,stats.Homogeneity];
     texture = [ texture ; texture_v ];  
 end
 Texture=[Texture,texture];
end
end


