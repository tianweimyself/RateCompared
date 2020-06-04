function [ y_l, indexOfNum ] = changed( original )
%CHANGED 此处显示有关此函数的摘要
%   此处显示详细说明

    x_l=original;
    y_l=zeros(size(original));
    n=sqrt(size(original,2));
    indexOfNum=zeros(1,size(original,2));

    direction={'right','down','left','up'};
    num=2;
    len=1;
    count=0;
    x=n/2;y=n/2;
    y_l(:,1)=x_l(:,(y-1)*n+x);
    indexOfNum(1)=(y-1)*n+x;
    dir=direction{1};

    while(num<=n*n)
        for i=1:len
            switch dir
                case 'right'
                    y=y+1;
                case 'left'
                    y=y-1; 
                case 'up'
                    x=x-1;
                case 'down'
                    x=x+1;
            end
    %          y_l(:,num)=x_l(:,x*n+y);
    %           num=num+1;
    %           if((y-1)*n+x>n*n)
    %               break;
    %           end
                y_l(:,num)=x_l(:,(y-1)*n+x);
                indexOfNum(num)=(y-1)*n+x;
                num=num+1;
                if num>n*n
                    break;
                end
        end
        count=count+1;
        if count==2
            count=0;
            len=len+1;
        end
        id=ismember(direction,dir);
        index=find(id);
        if index==1
            dir='down';
        elseif index==2
            dir='left';
        elseif index==3;
            dir='up';
        else
            dir='right';
        end
    end
%      y_l;
%      indexOfNum;

end

