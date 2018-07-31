% read an SS file
function[fea]=SS(fileName)
    % read file
    fid=fopen(fileName,'r');
    cel=textscan(fid,'%*d %*s %s %f %f %f %*[^\n]','HeaderLines',2);
    fclose(fid);
    % get secondary structure sequences
    global seq;
    seq=char(cel{1})';
    len=length(seq);
    seq=[seq,'0'];
    %SS sequence
    global sseq;     
    sseq='';
    count=zeros(1,3); 
    pos=zeros(1,3); 
    maxlen=zeros(1,3); 
    while(i<=len)
        if seq(i)=='H'
            [d1,d2,d3,d4]=Fea1(i,'H',maxlen(1));
            i=d1;
            count(1)=count(1)+d2;
            pos(1)=pos(1)+d3;
            maxlen(1)=d4;
        elseif seq(i)=='E'
            [d1,d2,d3,d4]=Fea1(i,'E',maxlen(2));
            i=d1;
            count(2)=count(2)+d2;
            pos(2)=pos(2)+d3;
            maxlen(2)=d4;
        elseif seq(i)=='C'
            [d1,d2,d3,d4]=Fea1(i,'C',maxlen(3));
            i=d1;
            count(3)=count(3)+d2;
            pos(3)=pos(3)+d3;
            maxlen(3)=d4;
        end
    end
    slen=length(sseq);
    scount=zeros(1,6);
    sseq=[sseq,'0'];
    for i=1:1:slen
        if sseq(i)=='A'
            scount(5)=scount(5)+1;
            if sseq(i+1)=='A'
                scount(1)=scount(1)+1;
            elseif sseq(i+1)=='B'
                scount(2)=scount(2)+1;
            end
        elseif sseq(i)=='B'
            scount(6)=scount(6)+1;
            if sseq(i+1)=='A'
                scount(3)=scount(3)+1;
            elseif sseq(i+1)=='B'
                scount(4)=scount(4)+1;
            end
        end
    end

    fea=zeros(1,20);
    for i=1:1:3
        fea(i)=count(i)/len;
        fea(3+i)=pos(i)/(len*(len-1));
        fea(6+i)=maxlen(i)/len;
    end
    if(scount(1)~=0||scount(2)~=0)
        fea(10)=scount(1)/(scount(1)+scount(2));
        fea(11)=scount(2)/(scount(1)+scount(2));
    end
    if(scount(3)~=0||scount(4)~=0)
        fea(12)=scount(3)/(scount(3)+scount(4));
        fea(13)=scount(4)/(scount(3)+scount(4));
    end
    fea(14)=(fea(10)+fea(12))/2;
    fea(15)=(fea(11)+fea(13))/2;
    fea(16)=mean(cel{2});
    fea(17)=mean(cel{3});
    fea(18)=mean(cel{4});
    fid=fopen('./neg-20.libsvm','a');
    fprintf(fid,'1 ');
    for i=1:18
        fprintf(fid,'%d:%f ',i,fea(i));
    end
    fprintf(fid,'\n');
    fclose(fid);
end