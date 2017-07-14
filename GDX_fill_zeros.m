function GDX_symbol_fill=GDX_fill_zeros(GDX_symbol,SETS)
% USAGE
% GDX_symbol_fill = GDX_fill_zeros(GDX_symbol,{SET_1,SET_2,SET_3,...});


GDX_symbol_fill=GDX_symbol;
NumberSets=length(SETS);

index=1;
switch NumberSets
    case {3}
        NSET(1)=length(SETS{1}.uels{1});
        NSET(2)=length(SETS{2}.uels{1});
        NSET(3)=length(SETS{3}.uels{1});
        GDX_symbol_fill.val=zeros(NSET);

        
        Ni=length(GDX_symbol.uels{1});
        Nj=length(GDX_symbol.uels{2});
        Nk=length(GDX_symbol.uels{3});
        
        for i=1:Ni
            for j=1:Nj
                for k=1:Nk
                    ii=strmatch(GDX_symbol.uels{1}{i},  SETS{1}.uels{1});
                    jj=strmatch(GDX_symbol.uels{2}{j},  SETS{2}.uels{1});
                    kk=strmatch(GDX_symbol.uels{3}{k},  SETS{3}.uels{1});
                    GDX_symbol_fill.val(ii,jj,kk)=GDX_symbol.val(i,j,k);
                end
            end
        end
        for i=1:Ni
            for j=1:Nj
                for k=1:Nk
                    GDX_symbol_fill.vector(index)=GDX_symbol_fill.val(i,j,k);
                    index=index+1;
                end
            end
        end
    
    case {2}
        NSET(1)=length(SETS{1}.uels{1});
        NSET(2)=length(SETS{2}.uels{1});
        GDX_symbol_fill.val=zeros(NSET);
        
        Ni=length(GDX_symbol.uels{1});
        Nj=length(GDX_symbol.uels{2});
        for i=1:Ni
            for j=1:Nj
                ii=strmatch(GDX_symbol.uels{1}{i},  SETS{1}.uels{1});
                jj=strmatch(GDX_symbol.uels{2}{j},  SETS{2}.uels{1});
                GDX_symbol_fill.val(ii,jj)   =GDX_symbol.val(i,j);
            end
        end
        for i=1:Ni
            for j=1:Nj
                GDX_symbol_fill.vector(index)=GDX_symbol_fill.val(i,j);
                index=index+1;
            end
        end
        
    case {1}
        NSET_1=length(SETS{1}.uels{1});
        GDX_symbol_fill.val=zeros(NSET_1,1);
        
        Ni=length(GDX_symbol.uels{1});
        for i=1:Ni       
                ii=strmatch(GDX_symbol.uels{1}{i},  SETS{1}.uels{1});         
                GDX_symbol_fill.val(ii)=GDX_symbol.val(i);
        end
        for i=1:Ni
            GDX_symbol_fill.vector(index)=GDX_symbol_fill.val(i);
            index=index+1;
        end

    otherwise
        disp{['Dimension of the GDX data is not supported'] };
   
end    

GDX_symbol_fill.name=GDX_symbol.name;
GDX_symbol_fill.form=GDX_symbol.form;
GDX_symbol_fill.dim=GDX_symbol.dim;
GDX_symbol_fill.vector=GDX_symbol_fill.vector';


