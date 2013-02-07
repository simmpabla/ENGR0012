%Jake Stambaugh
%Sim Pabla
%Erin Carlson
%Engineering 0012 T,Th. 2:00-4:00
%Instructor: Dr. Bursic
%Date: February 7
%
%Homework 6
%Script to create polynomial approximations of sets of data using splines

%This while loop encapsulates the entire program, allowing the user to run
%it multiple times.
rpeatA = 1;
while rpeatA == 1
    
    clear;
    clc;
    
    %This block of code uses a while loop, if statement and try-catch to
    %load the file and make sure that the user doesn't cause any errors.
    rpeatB = 1;
    while rpeatB == 1
        filename = input('What is the name of the file? ','s');
        if exist(filename)
            rpeatB = 0;
        else
            disp('Failed to locate file.')
        end
    end
    
    %These lines of code load the data file and create the rows and cols
    %variables based on the size of the file.
    data = load(filename);
    [rows, cols] = size(data);
    
    %This block of code compares the length of the rows to the columns to
    %see if the data is arranged horizontally or vertically. It then sets
    %the first row/col to x and the second one to y
    if cols > rows
        x = data(1,:);
        y = data(2,:);
    elseif rows > cols
        x = data(:,1);
        y = data(:,2);
    else
        disp('Not plottable data');
    end
    
    rpeatD = 1;
    while rpeatD == 1
        
        %Menu and switch statement that allows the user to choose the plot points.
        shapepick = menu('What shape would you like the points to be?','square','Xs','triangle up','circles','stars', 'plus','triangle down', 'triangle left','triangle right','pentagram','hexagram','diamond');
        
        switch shapepick
            case 1
                shapestring = 's';
            case 2
                shapestring = 'x';
            case 3
                shapestring = '^';
            case 4
                shapestring = 'o';
            case 5
                shapestring = '*';
            case 6
                shapestring = '+';
            case 7
                shapestring = 'v';
            case 8
                shapestring = '<';
            case 9
                shapestring = '>';
            case 10
                shapestring = 'p';
            case 11
                shapestring = 'h';
            case 12
                shapestring = 'd';
            otherwise
                shapestring = '.';
        end
        
        %Menu and switch statement that allows the user to choose the color of the scatter plot.
        colorpick = menu('What color would you like the points to be?','red','green','blue','black','white', 'cyan','maroon');
        
        switch colorpick
            case 1
                colorstring = 'r';
            case 2
                colorstring = 'g';
            case 3
                colorstring = 'b';
            case 4
                colorstring = 'k';
            case 5
                colorstring = 'w';
            case 6
                colorstring = 'c';
            case 7
                colorstring = 'm';
            otherwise
                colorstring = 'k';
        end
        
        %Make variable to use users choice of color and symbol.
        choices=[colorstring, shapestring];
        
        %Make variable to count the number of total data points.
        datas=length(x);
        
        %This block of code is used to sum up x, x^2, y, and y^2.
        sumx = 0;
        sumx2 = 0;
        sumy = 0;
        sumxy = 0;
        
        for i = 1:length(y)
            sumx2 = x(i)^2+sumx2;
            sumy = y(i)+sumy;
            sumx = x(i)+sumx;
            sumxy = y(i)*x(i)+sumxy;
        end
        
        %This takes the sums of the necessary values and arranges them into two
        %matricies.
        
        A = [sumx, datas; sumx2, sumx];
        b = [sumy; sumxy];
        
        coeff = inv(A)*b;
        
        %Here the user chooses if they want a linear or polynomial function.
        plot(x,y,choices)
        disp('Check the plot.  If correct, press any key to continue.');
        pause
        
        linetype=menu('What type of line are you fitting?','linear', 'polynomial', 'spline', 'semi-log', 'log-log');
        
        %This block of code plots the line on top of the existing scatter plot
        %in the color and pattern specified by the user
        
        lcolorpick = menu('What color would you like the best fit line to be?','red','green','blue','black','white', 'cyan','maroon');
        
        switch lcolorpick
            case 1
                lcolorstring = 'r';
            case 2
                lcolorstring = 'g';
            case 3
                lcolorstring = 'b';
            case 4
                lcolorstring = 'k';
            case 5
                lcolorstring = 'w';
            case 6
                lcolorstring = 'c';
            case 7
                lcolorstring = 'm';
            otherwise
                lcolorstring = 'k';
        end
        
        lstylepick = menu('What style would you like the line to be?', 'solid', 'dotted', 'dash-dot', 'dashed');
        
        switch lstylepick
            case 1
                lstylestring = '-';
            case 2
                lstylestring = ':';
            case 3
                lstylestring = '-.';
            case 4
                lstylestring = '--';
            otherwise
                lstylestring = '-';
        end
        
        if linetype == 1
            %This will plot the linear function.
            pequation = ['y = ',num2str(coeff(1)),'x + ',num2str(coeff(2))];
            new_x=linspace(min(x), max(x), 300);
            fitted_y=polyval(coeff,new_x);
               
        elseif linetype == 2
            %Here the user will choose the order of the polynomial they would like
            %to try.
            order=input('State the order of the polynomial you would like to try (2-9)');
            %This will check for the maximum order.
            while order>(datas-1)
                order=input('This order is not valid. Please enter a valid order here: ');
            end
            
            %This will plot a function of the chosen order.
            coeff = polyfit(x,y,order);
            new_x=linspace(min(x), max(x), 300);
            fitted_y=polyval(coeff,new_x);
            
            %This will plot the best fit line.
            %hold off
            
            %This uses the text command for the polynomial equation.
            pequation= ' y = ' ;
            for eqpower = order:-1:0
                pequation=[pequation, '+ ', num2str(coeff(order-eqpower+1)),'x^', num2str(eqpower)];
            end
        elseif linetype == 3
            %This will plot the linear function.
            pequation = ['y = ',num2str(coeff(1)),'x + ',num2str(coeff(2))];
            new_x=linspace(min(x), max(x), 300);
            fitted_y=polyval(coeff,new_x);
        end
        
        the_plot_title=input('What would you like the plot title to be? ','s');
        the_x_title=input('What would you like the x axis title to be? ','s');
        the_y_title=input('What would you like the y axis title to be? ','s');
        
        %This block of code calculates the r-squared value and maximum relative
        %and absolute errors.
        calc_y = polyval(coeff, x);
        abse = abs(y - calc_y);
        rele = abs((y - calc_y)./y);
        
        [max_abs, mxa_loc] = max(abse);
        [max_rel, mxr_loc] = max(rele);
        
        disp(['The maximum absolute error is ', num2str(max_abs), ' at x = ', num2str(x(mxa_loc))])
        disp(['The maximum relative error is ', num2str(max_rel), ' at x = ', num2str(x(mxr_loc))])
        
        sse = 0;
        sst = 0;
        
        plot(x,y,[colorstring, shapestring],new_x,fitted_y,[lcolorstring, lstylestring])
        
        title(the_plot_title);
        xlabel(the_x_title);
        ylabel(the_y_title);
        text(5,8,display_string)
        text(0,0,pequation)
        
        estimatedyvalue=input('Would you like to find an estimated y-value for an x-value? (y/n) ','s');
        if lower(estimatedyvalue(1))=='y'
            chosenxvalue=input('What x-value would you like to estimate for? ');
            yestimate=polyval(coeff,chosenxvalue);
            disp(['The estimated value is ', num2str(yestimate)])
        end
        
        i=0;
        
        while i==0
            runagain=input('Would you like to try again with a different polynomial fit? (y/n) ','s');
            if lower(runagain(1))=='y'
                rpeatD=1;
                i=1;
            elseif lower(runagain(1))=='n'
                rpeatD=0;
                i=1;
            else
                disp('You have to enter either y or n. Try again!');
                i=0;
            end
        end
    end
    %This block of code allows the user to decide whether or not to
    %continue using the program. The loop is used to prevent user error.
    rpeatC = 0;
    while rpeatC == 0
        exit_poll = input('Would you like to run the program again with a new data file? (y/n) ', 's');
        if exit_poll(1) == 'y' || exit_poll(1) == 'Y'
            disp('Running again!')
            rpeatA = 1;
            rpeatC = 1;
        elseif exit_poll(1) == 'n' || exit_poll(1) == 'N'
            disp('Goodbye!')
            rpeatA = 0;
            rpeatC = 1;
        else
            disp('Indecipherable, please use "y" or "n"')
        end
    end
end

