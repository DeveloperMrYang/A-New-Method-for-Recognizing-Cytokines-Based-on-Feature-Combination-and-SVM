% read a PSSM file
function [fileName]=read(fileName)
    %read file
    fid=fopen(fileName);
    cel=textscan(fid,'%*d %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]','HeaderLines',3);
    fclose(fid);
    res=cell2mat(cel);
    %judge
    if any(isnan(res))
        error('Nan !!!');
    end
    row=size(res,1);
    if row<20
        error('two short !!!');
    end
    % PSSM
    res=1./(1+exp(-res));
    ave=mean(res);
    fea=zeros(20,20);  %the final features
    for m=1:20
        for n=1:20
            D1=0;
            D2=0;
            for i=1:row
                D1=D1+(res(i,m)-ave(1,m))^2;
                D2=D2+(res(i,n)-ave(1,n))^2;
            end
            D1=sqrt(D1/row);
            D2=sqrt(D2/row);             %±ê×¼²î
            g=abs(m-n); 
            for j=1:row-g
                M=(res(j,m)-ave(1,m))*(res(j+g,n)-ave(1,n))/(D1*D2);
                fea(m,n)=fea(m,n)+M;
            end
            fea(m,n)=fea(m,n)/(row-g);
        end
    end
%     20 features 
%     fid=fopen('./neg-20pssm.libsvm','a');
%     fprintf(fid,'1 ');
%     for i=1:20
%             fprintf(fid,'%d:%f ',i,ave(i));
%     end
%     fprintf(fid,'\n');
%     fclose(fid);

%   380 features
    fid=fopen('./neg-380pssm.libsvm','a');
    fprintf(fid,'1 ');
    count=1;
    for i=1:20
        for j=1:20
            if i~=j
                fprintf(fid,'%d:%f ',count,fea(i,j));
                count=count+1;
            end
        end
    end
    fprintf(fid,'\n');
    fclose(fid);
end