function y = evaluate_interpolating_surface(x,model)
    
    firstTerm = 0;    
    for k = 1:length(model.a)
        firstTerm = firstTerm + model.a(k) * model.pi{k}(x);
    end
    
    secondTerm = 0;
    for i = 1:length(model.b)   
      secondTerm =  secondTerm + model.b(i) * model.phi( x - model.samplePoints(i,:) )   ;        
    end

    y = firstTerm + secondTerm;


end