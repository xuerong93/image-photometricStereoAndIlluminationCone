function z= findDepth( height,width,p,q,x_start,y_start,error) 
z(x_start,y_start)=0;
for x=x_start:1:height-1
    if(abs(q(x+1,y_start)-q(x,y_start))>error)
        z(x+1,y_start)=z(x,y_start);
    else
        z(x+1,y_start)=z(x,y_start)+q(x,y_start);
    end
end
 
for x=x_start:-1:2
    if(abs(q(x-1,y_start)-q(x,y_start))>error)
        z(x-1,y_start)=z(x,y_start);
    else
        z(x-1,y_start)=z(x,y_start)-q(x-1,y_start);
    end
end

 for x=1:height
     for y=y_start:width-1
        if(abs(p(x,y)-p(x,y+1))>error)
            z(x,y+1)=z(x,y);
        else
            z(x,y+1)=z(x,y)-p(x,y);
        end
     end
end
 
for x=1:height
     for y=y_start:-1:2
        if(abs(p(x,y-1)-p(x,y))>error)
            z(x,y-1)=z(x,y);
        else
            z(x,y-1)=z(x,y)+p(x,y-1);
        end
     end
end

%  for y=y_start:1:width-1
%         if(abs(p(x_start,y)-p(x_start,y+1))>error)
%             z(x_start,y+1)=z(x_start,y);
%         else
%             z(x_start,y+1)=z(x_start,y)-p(x_start,y);
%         end 
% end
%  
%  for y=y_start:-1:2
%         if(abs(p(x_start,y)-p(x_start,y-1))>error)
%             z(x_start,y-1)=z(x_start,y);
%         else
%             z(x_start,y-1)=z(x_start,y)+p(x_start,y-1);
%         end 
%  end
% 
%  for y=1:width
%      for x=x_start:height-1
%         if(abs(q(x+1,y)-q(x,y))>error)
%             z(x+1,y)=z(x,y);
%         else
%             z(x+1,y)=z(x,y)+q(x,y);
%         end
%      end
%  end
%   for y=1:width
%      for x=x_start:-1:2
%         if(abs(q(x-1,y)-q(x,y))>error)
%             z(x-1,y)=z(x,y);
%         else
%             z(x-1,y)=z(x,y)-q(x-1,y);
%         end
%      end
%   end
    
end
 
