clc, clear, clf
%poker.m
%This simple program is a basic draw poker game.
%Answer the questions with yes or no (or y/n) and then input values for
%bets. To end the game, input a bet of 0. The game will also end if you run
%out of chips.

%The first sets define simple variables that may be used
y=1;
n=0;
yes=1;
no=0;

%Ask to start the game
play=input('Are ready to go?   ');

%Loop for how it starts
if play==0
   disp('Whatever, you pussy.')
elseif play==1
    chips=10;
    disp('You start with 10 chips.  Use them well.')
elseif play==69
    chips=69;
    disp('Whoohoo, enjoy your money!!!')
else
    disp('Huh???')
end

%This game number section resets the random list.
disp('Please click on the graph window and hit enter to select a randomizing number.')
plot(50,50)
axis([0 100 0 100])
[game_number,not_used]=ginput(1);
game_number=floor(game_number);
if game_number>0
    game_number=ceil(game_number);
    rand(game_number);
else
    game_number=1;
    rand(game_number);
end
clc
handbet=17;

%Loop to make it go
while handbet~=0 & chips>0
    %for loop to increase randomness
    c=ceil(20*rand(1));
    for d=1:c
        r=rand(d);
    end
    handbet=input('How much you gonna bet?   ');
    clf,clc
    
    %To make sure they don't bet over their limit and give a kill switch
    if handbet>chips
    while handbet>chips
        disp('Insufficient funds...not to mention other insufficient quantities...')
        handbet=input('How much you gonna bet?   ');
    end
    end
    
    if handbet==0
        play=0;
    %Looping for how the hand will play out
    elseif handbet<=chips
       
        %Forms the hand
        for i=1:5
            ranks(i)=ceil(13*rand(1));
            suits(i)=ceil(4*rand(1));
        end
       
        %Makes sure there are no dublicate cards.
        while (ranks(1)==ranks(2) & suits(1)==suits(2)) | (ranks(1)==ranks(3) & suits(1)==suits(3)) | (ranks(1)==ranks(4) & suits(1)==suits(4)) | (ranks(1)==ranks(5) & suits(1)==suits(5)) | (ranks(2)==ranks(3) & suits(2)==suits(3)) | (ranks(2)==ranks(4) & suits(2)==suits(4)) | (ranks(2)==ranks(5) & suits(2)==suits(5)) | (ranks(3)==ranks(4) & suits(3)==suits(4)) | (ranks(3)==ranks(5) & suits(3)==suits(5)) | (ranks(4)==ranks(5) & suits(4)==suits(5)) 
              for i=1:5
                  ranks(i)=ceil(13*rand(1));
                  suits(i)=ceil(4*rand(1));
              end
        end
        hand=[ranks;suits];
        straighthand=sort(ranks);

        for i=1:5
            if ranks(i)==1
                rank_name='Ace';
            elseif ranks(i)==2
                rank_name='Deuce';
            elseif ranks(i)==3
                rank_name='Tre';
            elseif ranks(i)==4
                rank_name='Four';
            elseif ranks(i)==5
                rank_name='Five';
            elseif ranks(i)==6
                rank_name='Six';
            elseif ranks(i)==7
                rank_name='Seven';
            elseif ranks(i)==8
                rank_name='Eight';
            elseif ranks(i)==9
                rank_name='Nine';
            elseif ranks(i)==10
                rank_name='Ten';
            elseif ranks(i)==11
                rank_name='Jack';
            elseif ranks(i)==12
                rank_name='Queen';
            elseif ranks(i)==13
                rank_name='King';
            end
            if suits(i)==1
                suit_name='Clubs';
            elseif suits(i)==2
                suit_name='Diamonds';
            elseif suits(i)==3
                suit_name='Hearts';
            elseif suits(i)==4
                suit_name='Spades';
            end
            fprintf('You have the %s of %s\n',rank_name,suit_name)
        end
        
        %graphics region
        axis([0 25 0 7])
        axis off
        text(3, 1,'Click on cards to throw away and hit return when ready to draw.')
        if ranks(1)==1
            text(1,6,'Ace')
        elseif ranks(1)==2
            text(1,6,'Deuce')
        elseif ranks(1)==3
            text(1,6,'Tre')
        elseif ranks(1)==4
            text(1,6,'Four')
        elseif ranks(1)==5
            text(1,6,'Five')
        elseif ranks(1)==6
            text(1,6,'Six')
        elseif ranks(1)==7
            text(1,6,'Seven')
        elseif ranks(1)==8
            text(1,6,'Eight')
        elseif ranks(1)==9
            text(1,6,'Nine')
        elseif ranks(1)==10
            text(1,6,'Ten')
        elseif ranks(1)==11
            text(1,6,'Jack')
        elseif ranks(1)==12
            text(1,6,'Queen')
        elseif ranks(1)==13
            text(1,6,'King')
        end
        if suits(1)==1
            text(1,5,'Clubs')
        elseif suits(1)==2
            text(1,5,'Diamonds')
        elseif suits(1)==3
            text(1,5,'Hearts')
        elseif suits(1)==4
            text(1,5,'Spades')
        end
        
        if ranks(2)==1
            text(6,6,'Ace')
        elseif ranks(2)==2
            text(6,6,'Deuce')
        elseif ranks(2)==3
            text(6,6,'Tre')
        elseif ranks(2)==4
            text(6,6,'Four')
        elseif ranks(2)==5
            text(6,6,'Five')
        elseif ranks(2)==6
            text(6,6,'Six')
        elseif ranks(2)==7
            text(6,6,'Seven')
        elseif ranks(2)==8
            text(6,6,'Eight')
        elseif ranks(2)==9
            text(6,6,'Nine')
        elseif ranks(2)==10
            text(6,6,'Ten')
        elseif ranks(2)==11
            text(6,6,'Jack')
        elseif ranks(2)==12
            text(6,6,'Queen')
        elseif ranks(2)==13
            text(6,6,'King')
        end
        if suits(2)==1
            text(6,5,'Clubs')
        elseif suits(2)==2
            text(6,5,'Diamonds')
        elseif suits(2)==3
            text(6,5,'Hearts')
        elseif suits(2)==4
            text(6,5,'Spades')
        end
        if ranks(3)==1
            text(11,6,'Ace')
        elseif ranks(3)==2
            text(11,6,'Deuce')
        elseif ranks(3)==3
            text(11,6,'Tre')
        elseif ranks(3)==4
            text(11,6,'Four')
        elseif ranks(3)==5
            text(11,6,'Five')
        elseif ranks(3)==6
            text(11,6,'Six')
        elseif ranks(3)==7
            text(11,6,'Seven')
        elseif ranks(3)==8
            text(11,6,'Eight')
        elseif ranks(3)==9
            text(11,6,'Nine')
        elseif ranks(3)==10
            text(11,6,'Ten')
        elseif ranks(3)==11
            text(11,6,'Jack')
        elseif ranks(3)==12
            text(11,6,'Queen')
        elseif ranks(3)==13
            text(11,6,'King')
        end
        if suits(3)==1
            text(11,5,'Clubs')
        elseif suits(3)==2
            text(11,5,'Diamonds')
        elseif suits(3)==3
            text(11,5,'Hearts')
        elseif suits(3)==4
            text(11,5,'Spades')
        end
        if ranks(4)==1
            text(16,6,'Ace')
        elseif ranks(4)==2
            text(16,6,'Deuce')
        elseif ranks(4)==3
            text(16,6,'Tre')
        elseif ranks(4)==4
            text(16,6,'Four')
        elseif ranks(4)==5
            text(16,6,'Five')
        elseif ranks(4)==6
            text(16,6,'Six')
        elseif ranks(4)==7
            text(16,6,'Seven')
        elseif ranks(4)==8
            text(16,6,'Eight')
        elseif ranks(4)==9
            text(16,6,'Nine')
        elseif ranks(4)==10
            text(16,6,'Ten')
        elseif ranks(4)==11
            text(16,6,'Jack')
        elseif ranks(4)==12
            text(16,6,'Queen')
        elseif ranks(4)==13
            text(16,6,'King')
        end
        if suits(4)==1
            text(16,5,'Clubs')
        elseif suits(4)==2
            text(16,5,'Diamonds')
        elseif suits(4)==3
            text(16,5,'Hearts')
        elseif suits(4)==4
            text(16,5,'Spades')
        end
        if ranks(5)==1
            text(21,6,'Ace')
        elseif ranks(5)==2
            text(21,6,'Deuce')
        elseif ranks(5)==3
            text(21,6,'Tre')
        elseif ranks(5)==4
            text(21,6,'Four')
        elseif ranks(5)==5
            text(21,6,'Five')
        elseif ranks(5)==6
            text(21,6,'Six')
        elseif ranks(5)==7
            text(21,6,'Seven')
        elseif ranks(5)==8
            text(21,6,'Eight')
        elseif ranks(5)==9
            text(21,6,'Nine')
        elseif ranks(5)==10
            text(21,6,'Ten')
        elseif ranks(5)==11
            text(21,6,'Jack')
        elseif ranks(5)==12
            text(21,6,'Queen')
        elseif ranks(5)==13
            text(21,6,'King')
        end
        if suits(5)==1
            text(21,5,'Clubs')
        elseif suits(5)==2
            text(21,5,'Diamonds')
        elseif suits(5)==3
            text(21,5,'Hearts')
        elseif suits(5)==4
            text(21,5,'Spades')
        end
        %cards to be held
        fprintf('\n')
        [held_card_x,held_card_y]=ginput;
        clc
        for j=1:length(held_card_x)
            if held_card_x(j)<3 & held_card_x(j)>=0
                ranks(1)=ceil(13*rand(1));
                suits(1)=ceil(4*rand(1));
                 while (ranks(1)==ranks(2) & suits(1)==suits(2)) | (ranks(1)==ranks(3) & suits(1)==suits(3)) | (ranks(1)==ranks(4) & suits(1)==suits(4)) | (ranks(1)==ranks(5) & suits(1)==suits(5))
                 ranks(1)=ceil(13*rand(1));
                 suits(1)=ceil(4*rand(1));
                end
            elseif held_card_x(j)<8 & held_card_x(j)>=3
                ranks(2)=ceil(13*rand(1));
                suits(2)=ceil(4*rand(1));
                 while (ranks(1)==ranks(2) & suits(1)==suits(2)) | (ranks(2)==ranks(3) & suits(2)==suits(3)) | (ranks(2)==ranks(4) & suits(2)==suits(4)) | (ranks(2)==ranks(5) & suits(2)==suits(5))
                  ranks(2)=ceil(13*rand(1));
                  suits(2)=ceil(4*rand(1));
                end
            elseif held_card_x(j)<13 & held_card_x(j)>=8
                ranks(3)=ceil(13*rand(1));
                suits(3)=ceil(4*rand(1));
                 while (ranks(1)==ranks(3) & suits(1)==suits(3)) | (ranks(2)==ranks(3) & suits(2)==suits(3)) | (ranks(3)==ranks(4) & suits(3)==suits(4)) | (ranks(3)==ranks(5) & suits(3)==suits(5))
                 ranks(3)=ceil(13*rand(1));
                 suits(3)=ceil(4*rand(1));
             end
            elseif held_card_x(j)<19 & held_card_x(j)>=13
                ranks(4)=ceil(13*rand(1));
                suits(4)=ceil(4*rand(1));
                 while (ranks(1)==ranks(4) & suits(1)==suits(4)) | (ranks(2)==ranks(4) & suits(2)==suits(4)) | (ranks(3)==ranks(4) & suits(3)==suits(4)) | (ranks(4)==ranks(5) & suits(4)==suits(5)) 
                  ranks(4)=ceil(13*rand(1));
                  suits(4)=ceil(4*rand(1));
              end
          elseif held_card_x(j)<25 & held_card_x(j)>=19
                ranks(5)=ceil(13*rand(1));
                suits(5)=ceil(4*rand(1));
                 while (ranks(1)==ranks(5) & suits(1)==suits(5)) | (ranks(2)==ranks(5) & suits(2)==suits(5)) | (ranks(3)==ranks(5) & suits(3)==suits(5)) | (ranks(4)==ranks(5) & suits(4)==suits(5)) 
                ranks(5)=ceil(13*rand(1));
                suits(5)=ceil(4*rand(1));
              end
          end
        end
       
        clf
        axis([0 25 0 7])
        axis off
         for l=1:5
            if ranks(l)==1
                rank_name='Ace';
            elseif ranks(l)==2
                rank_name='Deuce';
            elseif ranks(l)==3
                rank_name='Tre';
            elseif ranks(l)==4
                rank_name='Four';
            elseif ranks(l)==5
                rank_name='Five';
            elseif ranks(l)==6
                rank_name='Six';
            elseif ranks(l)==7
                rank_name='Seven';
            elseif ranks(l)==8
                rank_name='Eight';
            elseif ranks(l)==9
                rank_name='Nine';
            elseif ranks(l)==10
                rank_name='Ten';
            elseif ranks(l)==11
                rank_name='Jack';
            elseif ranks(l)==12
                rank_name='Queen';
            elseif ranks(l)==13
                rank_name='King';
            end
            if suits(l)==1
                suit_name='Clubs';
            elseif suits(l)==2
                suit_name='Diamonds';
            elseif suits(l)==3
                suit_name='Hearts';
            elseif suits(l)==4
                suit_name='Spades';
            end
            fprintf('You have the %s of %s\n',rank_name,suit_name)
        end
        if ranks(1)==1
            text(1,6,'Ace')
        elseif ranks(1)==2
            text(1,6,'Deuce')
        elseif ranks(1)==3
            text(1,6,'Tre')
        elseif ranks(1)==4
            text(1,6,'Four')
        elseif ranks(1)==5
            text(1,6,'Five')
        elseif ranks(1)==6
            text(1,6,'Six')
        elseif ranks(1)==7
            text(1,6,'Seven')
        elseif ranks(1)==8
            text(1,6,'Eight')
        elseif ranks(1)==9
            text(1,6,'Nine')
        elseif ranks(1)==10
            text(1,6,'Ten')
        elseif ranks(1)==11
            text(1,6,'Jack')
        elseif ranks(1)==12
            text(1,6,'Queen')
        elseif ranks(1)==13
            text(1,6,'King')
        end
        if suits(1)==1
            text(1,5,'Clubs')
        elseif suits(1)==2
            text(1,5,'Diamonds')
        elseif suits(1)==3
            text(1,5,'Hearts')
        elseif suits(1)==4
            text(1,5,'Spades')
        end
        
        if ranks(2)==1
            text(6,6,'Ace')
        elseif ranks(2)==2
            text(6,6,'Deuce')
        elseif ranks(2)==3
            text(6,6,'Tre')
        elseif ranks(2)==4
            text(6,6,'Four')
        elseif ranks(2)==5
            text(6,6,'Five')
        elseif ranks(2)==6
            text(6,6,'Six')
        elseif ranks(2)==7
            text(6,6,'Seven')
        elseif ranks(2)==8
            text(6,6,'Eight')
        elseif ranks(2)==9
            text(6,6,'Nine')
        elseif ranks(2)==10
            text(6,6,'Ten')
        elseif ranks(2)==11
            text(6,6,'Jack')
        elseif ranks(2)==12
            text(6,6,'Queen')
        elseif ranks(2)==13
            text(6,6,'King')
        end
        if suits(2)==1
            text(6,5,'Clubs')
        elseif suits(2)==2
            text(6,5,'Diamonds')
        elseif suits(2)==3
            text(6,5,'Hearts')
        elseif suits(2)==4
            text(6,5,'Spades')
        end
        if ranks(3)==1
            text(11,6,'Ace')
        elseif ranks(3)==2
            text(11,6,'Deuce')
        elseif ranks(3)==3
            text(11,6,'Tre')
        elseif ranks(3)==4
            text(11,6,'Four')
        elseif ranks(3)==5
            text(11,6,'Five')
        elseif ranks(3)==6
            text(11,6,'Six')
        elseif ranks(3)==7
            text(11,6,'Seven')
        elseif ranks(3)==8
            text(11,6,'Eight')
        elseif ranks(3)==9
            text(11,6,'Nine')
        elseif ranks(3)==10
            text(11,6,'Ten')
        elseif ranks(3)==11
            text(11,6,'Jack')
        elseif ranks(3)==12
            text(11,6,'Queen')
        elseif ranks(3)==13
            text(11,6,'King')
        end
        if suits(3)==1
            text(11,5,'Clubs')
        elseif suits(3)==2
            text(11,5,'Diamonds')
        elseif suits(3)==3
            text(11,5,'Hearts')
        elseif suits(3)==4
            text(11,5,'Spades')
        end
        if ranks(4)==1
            text(16,6,'Ace')
        elseif ranks(4)==2
            text(16,6,'Deuce')
        elseif ranks(4)==3
            text(16,6,'Tre')
        elseif ranks(4)==4
            text(16,6,'Four')
        elseif ranks(4)==5
            text(16,6,'Five')
        elseif ranks(4)==6
            text(16,6,'Six')
        elseif ranks(4)==7
            text(16,6,'Seven')
        elseif ranks(4)==8
            text(16,6,'Eight')
        elseif ranks(4)==9
            text(16,6,'Nine')
        elseif ranks(4)==10
            text(16,6,'Ten')
        elseif ranks(4)==11
            text(16,6,'Jack')
        elseif ranks(4)==12
            text(16,6,'Queen')
        elseif ranks(4)==13
            text(16,6,'King')
        end
        if suits(4)==1
            text(16,5,'Clubs')
        elseif suits(4)==2
            text(16,5,'Diamonds')
        elseif suits(4)==3
            text(16,5,'Hearts')
        elseif suits(4)==4
            text(16,5,'Spades')
        end
        if ranks(5)==1
            text(21,6,'Ace')
        elseif ranks(5)==2
            text(21,6,'Deuce')
        elseif ranks(5)==3
            text(21,6,'Tre')
        elseif ranks(5)==4
            text(21,6,'Four')
        elseif ranks(5)==5
            text(21,6,'Five')
        elseif ranks(5)==6
            text(21,6,'Six')
        elseif ranks(5)==7
            text(21,6,'Seven')
        elseif ranks(5)==8
            text(21,6,'Eight')
        elseif ranks(5)==9
            text(21,6,'Nine')
        elseif ranks(5)==10
            text(21,6,'Ten')
        elseif ranks(5)==11
            text(21,6,'Jack')
        elseif ranks(5)==12
            text(21,6,'Queen')
        elseif ranks(5)==13
            text(21,6,'King')
        end
        if suits(5)==1
            text(21,5,'Clubs')
        elseif suits(5)==2
            text(21,5,'Diamonds')
        elseif suits(5)==3
            text(21,5,'Hearts')
        elseif suits(5)==4
            text(21,5,'Spades')
        end
        %Evaluates how much is won or lost
        straighthand=sort(ranks);
        %Royal Flush
        if (suits(1)==suits(2) & suits(2)==suits(3) & suits(3)==suits(4) & suits(4)==suits(5)) & (straighthand(1)==1 & straighthand(2)==10 & straighthand(3)==11 & straighthand(4)==12 & straighthand(5)==13)
            chips=chips+10*handbet;
            text(3,1,'Holy cow!!! A Royal Flush!!')
            
        %straight flush
        elseif (suits(1)==suits(2) & suits(2)==suits(3) & suits(3)==suits(4) & suits(4)==suits(5)) & (straighthand(1)==straighthand(2)-1 & straighthand(2)==straighthand(3)-1 & straighthand(3)==straighthand(4)-1 & straighthand(4)==straighthand(5)-1)
            chips=chips+8*handbet;
            text(3,1,'There it is, a straight flush.')
           
        %flush
        elseif suits(1)==suits(2) & suits(2)==suits(3) & suits(3)==suits(4) & suits(4)==suits(5)
            chips=chips+5*handbet;
            text(3,1,'Nice hand.  You got a flush.')
            
        %four of a kind
        elseif (ranks(1)==ranks(2) & ranks(2)==ranks(3) & ranks(3)==ranks(4)) | (ranks(1)==ranks(2) & ranks(2)==ranks(3) & ranks(3)==ranks(5)) | (ranks(1)==ranks(2) & ranks(2)==ranks(5) & ranks(5)==ranks(4)) | (ranks(1)==ranks(5) & ranks(5)==ranks(3) & ranks(3)==ranks(4)) | (ranks(5)==ranks(2) & ranks(2)==ranks(3) & ranks(3)==ranks(4))
            chips=chips+7*handbet;
            text(3,1,'WHAT?!?!  Four of a kind!  Booya!!!')
        
        %full house
        elseif ((ranks(1)==ranks(2) & ranks(2)==ranks(3)) & ranks(4)==ranks(5)) | ((ranks(1)==ranks(2) & ranks(2)==ranks(4)) & ranks(3)==ranks(5)) | ((ranks(1)==ranks(2) & ranks(2)==ranks(5)) & ranks(3)==ranks(4)) | ((ranks(1)==ranks(3) & ranks(3)==ranks(4)) & ranks(2)==ranks(5)) | ((ranks(1)==ranks(3) & ranks(1)==ranks(5)) & ranks(2)==ranks(4)) | ((ranks(1)==ranks(4) & ranks(1)==ranks(5)) & ranks(2)==ranks(3)) | ((ranks(2)==ranks(3) & ranks(2)==ranks(4)) & ranks(1)==ranks(5)) | ((ranks(2)==ranks(3) & ranks(2)==ranks(5))  & ranks(1)==ranks(4)) | ((ranks(2)==ranks(4) & ranks(2)==ranks(5)) & ranks(1)==ranks(3)) | ((ranks(3)==ranks(4) & ranks(4)==ranks(5)) & ranks(2)==ranks(3))
            chips=chips+6*handbet;
            text(3,1,'Woohoo!!! Full boat baby!!!')
            
        %straight
        elseif (straighthand(1)==straighthand(2)-1 & straighthand(2)==straighthand(3)-1 & straighthand(3)==straighthand(4)-1 & straighthand(4)==straighthand(5)-1) | (straighthand(1)==1 & straighthand(2)==10 & straighthand(3)==11 & straighthand(4)==12 & straighthand(5)==13)
            chips=chips+4*handbet;
            text(3,1,'Oh yeah, that is a straight')
        
        %Set    
        elseif (ranks(1)==ranks(2) & ranks(2)==ranks(3)) | (ranks(1)==ranks(2) & ranks(2)==ranks(4)) | (ranks(1)==ranks(2) & ranks(2)==ranks(5)) | (ranks(1)==ranks(3) & ranks(3)==ranks(4)) | (ranks(1)==ranks(3) & ranks(1)==ranks(5)) | (ranks(1)==ranks(4) & ranks(1)==ranks(5)) | (ranks(2)==ranks(3) & ranks(2)==ranks(4)) | (ranks(2)==ranks(3) & ranks(2)==ranks(5)) | (ranks(2)==ranks(4) & ranks(2)==ranks(5)) | (ranks(3)==ranks(4) & ranks(4)==ranks(5))
            chips=chips+3*handbet;
            text(3,1,'A set, not too shabby.')
       
        %two pair
        elseif ((ranks(1)==ranks(2) | ranks(1)==ranks(3) | ranks(1)==ranks(4) | ranks(1)==ranks(5)) & (ranks(2)==ranks(3) | ranks(2)==ranks(4) | ranks(2)==ranks(5) | ranks(3)==ranks(4) | ranks(3)==ranks(5) | ranks(4)==ranks(5)) | ((ranks(2)==ranks(3) | ranks(2)==ranks(4) | ranks(2)==ranks(5)) & (ranks(3)==ranks(4) | ranks(3)==ranks(5) | ranks(4)==ranks(5))) | ((ranks(3)==ranks(4) | ranks(3)==ranks(5)) & ranks(4)==ranks(5)))
            chips=chips+2*handbet;
            text(3,1,'Two pair, respectable, even if you suck...')
            
        %pair    
        elseif (ranks(1)==ranks(2) | ranks(1)==ranks(3) | ranks(1)==ranks(4) | ranks(1)==ranks(5) | ranks(2)==ranks(3) | ranks(2)==ranks(4) | ranks(2)==ranks(5) | ranks(3)==ranks(4) | ranks(3)==ranks(5) | ranks(4)==ranks(5))
            chips=chips+handbet;
            text(3,1,'You got a pair, you lose no money')
        else
            text(5,1,'You have nothing.  You lose your bet.')
        end
    end
    %Gives payout
    chips=chips-handbet;
    if chips>0
        fprintf('You have %1.0f chips left\n',chips)
    elseif chips<0
        disp('You are out of chips')        
    end
end
