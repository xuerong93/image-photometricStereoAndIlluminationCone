clc;clear all;close all;
a1=imread('A1.jpg');a2=imread('A2.jpg');a3=imread('A3.jpg');a4=imread('A4.jpg');a5=imread('A5.jpg');
[height1,width1]=size(a1);

b1=imread('B1.bmp');b2=imread('B2.bmp');b3=imread('B3.bmp');b4=imread('B4.bmp');b5=imread('B5.bmp');b6=imread('B6.bmp');b7=imread('B7.bmp');
[height2,width2]=size(b1);
%photonetric stereo part
lll=cos(pi/6)*sin(pi/4);
S1=[0 0 1];S2=[lll -lll 0.5];S3=[-lll -lll 0.5];S4=[lll lll 0.5];S5=[-lll lll 0.5];
V1=255*[S1;S2;S3;S4;S5];
V2= 255*[0.1 0 0.995; 0.8 0 0.6; 0.707 0 0.707; -0.707 0 0.707; 0 0.707 0.707; 0.56568 0.56568 0.6; -0.56568 0.56568 0.6];
%get albedo and normal of figure set 1
for x=1:1:height1
    for y=1:1:width1
        i1=[a1(x,y) a2(x,y) a3(x,y) a4(x,y) a5(x,y)]';
        [albedo1,normal1]=findNormal(V1,i1);
        Albedo1(x,y)=albedo1;
        if(x==1||y==1)
            N1(x,y,:)=[0;0;0];
        else
            N1(x,y,:)=normal1';
        end
        if (normal1(3,1)==0||x==1||y==1)
            p1(x,y)=0;
            q1(x,y)=0;
        else
            p1(x,y)=normal1(1,1)/normal1(3,1);
            q1(x,y)=normal1(2,1)/normal1(3,1);
        end
    end 
end
%get albedo and normal of figure set 2
for x=1:1:height2
    for y=1:1:width2
        i2=[b1(x,y) b2(x,y) b3(x,y) b4(x,y) b5(x,y) b6(x,y) b7(x,y)]';
        [albedo2,normal2]=findNormal(V2,i2);
        Albedo2(x,y)=albedo2;
        if(x==1||y==1)
            N2(x,y,:)=[0;0;0];
        else
            N2(x,y,:)=normal2';
        end
        if (normal2(3,1)==0||x==1||y==1)
            p2(x,y)=0;
            q2(x,y)=0;
        else
            p2(x,y)=normal2(1,1)/normal2(3,1);
            q2(x,y)=normal2(2,1)/normal2(3,1);
        end
    end 
end
 
x_start1=round(height1/2)-60;y_start1=round(width1/2)-60;
x_start2=round(height2/2)-50;y_start2=round(width2/2)-30;
error=0.5;
 %get depth of the image
z1=findDepth( height1,width1,p1,q1,x_start1,y_start1,error);
z2=findDepth(height2,width2,p2,q2,x_start2,y_start2,error);

figure(1);
for h=1:20:height1
    for w=1:20:width1
         Z1=z1(h,w);
         N_1=N1(h,w,1);
         N_2=N1(h,w,2);
         N_3=N1(h,w,3);
         quiver3(h,w,Z1,-N_2,N_1,N_3,'LineWidth',1,'LineStyle','-','MaxHeadSize',2,'AutoScaleFactor',20);
         hold on;
    end
end   
figure(2);surf(1:20:height1,1:20:width1,z1(1:20:height1,1:20:width1));
figure(3);imshow(a1);surf(z1',a1','edgecolor','none','FaceColor','texturemap');

figure(4);
for h=1:10:height2
    for w=1:10:width2
         Z2=z2(h,w);
         N_1=N2(h,w,1);
         N_2=N2(h,w,2);
         N_3=N2(h,w,3);
         quiver3(h,w,Z2,-N_2,N_1,N_3,'LineWidth',1,'LineStyle','-','MaxHeadSize',3,'AutoScaleFactor',5);
         hold on;
    end
end
% figure(9);mesh(p2(:,1:360),p2(1:340,:));
% figure(10);mesh(q2(:,1:360),q2(1:340,:));
figure(5);mesh(z2(1:10:height2,1:10:width2));
figure(6);imshow(b1);surf(z2',b1','edgecolor','none','FaceColor','texturemap');

%illumination cone part
%make circle video of illumination cone
figure(7);
alb1=cat(3,Albedo1,Albedo1,Albedo1);
norm1=cat(3,N1(:,:,1),N1(:,:,2),N1(:,:,3));
B1_an=alb1.*norm1;
B1_vec=reshape(B1_an,height1*width1,3);
circle=zeros(height1,width1,3);
count1 = 1;
 video = VideoWriter('circle.avi');
 open(video);
 theta11=0;theta12=pi/2;bb=pi/8;
 phi11=0;phi12=2*pi; aa=pi/16; 
 for theta=theta11:bb:theta12
    for phi=phi11:aa:phi12
        S12 = 255*[cos(phi)*sin(theta) sin(theta)*sin(phi) cos(theta)]';
        b12 = max(B1_vec * S12,0);
        temp_mat = reshape(b12,height1,width1);
        circle = cat(3,reshape(b12,height1,width1),reshape(b12,height1,width1),reshape(b12,height1,width1));
        imshow(uint8(circle));
        X1_set{count1}=temp_mat;
        count1 = count1+1;
        writeVideo(video, uint8(temp_mat));    
%         imagesc(X_set{(fi/(fif/3))+1,(theta/(thetaf/4))+1});
    end
end
 image_tensor = cat(3,X1_set{:});
 close(video);
%make cup video of illumination cone
figure(8);
alb2=cat(3,Albedo2,Albedo2,Albedo2);
norm2=cat(3,N2(:,:,1),N2(:,:,2),N2(:,:,3));
B2_an=alb2.*norm2;
B2_vec=reshape(B2_an,height2*width2,3);
cup=zeros(340,360,3);
count2 = 1;
 video = VideoWriter('cup.avi');
 open(video);
 theta21=0;theta22=pi/2;bbb=pi/8;
 phi21=0;phi22=2*pi; aaa=pi/16; 
 for theta=theta21:bbb:theta22
    for phi=phi21:aaa:phi22
        S22 = 255*[cos(phi)*sin(theta) sin(theta)*sin(phi) cos(theta)]';
        b22 = max(B2_vec * S22,0);
        temp_mat = reshape(b22,height2,width2);
        cup = cat(3,reshape(b22,height2,width2),reshape(b22,height2,width2),reshape(b22,height2,width2));
        imshow(uint8(cup));
        X2_set{count2}=temp_mat;
        count2 = count2+1;
        writeVideo(video, uint8(temp_mat));    
%         imagesc(X_set{(fi/(fif/3))+1,(theta/(thetaf/4))+1});
    end
end
 image_tensor = cat(3,X2_set{:});
 close(video);
