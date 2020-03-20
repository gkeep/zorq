unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, dateutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    place: Integer;
    easymode: Boolean;
    hp, enemyHP: Integer;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
   ListBox1.Items.add ('Welcome to ZORQ.');
   ListBox1.Items.add (' ------ ');
   ListBox1.Items.add ('This is an open field west of a white house, with a boarded front door.');
   ListBox1.Items.Add ('  A secret path leads southwest into the forest.');
   ListBox1.Items.add ('There is a small mailbox here.');
   ListBox1.Items.add ('A rubber mat saying "Welcome to Zorq!" lies by the door.');
   ListBox1.Items.add (' ------ ');
   ListBox1.Items.add ('Type "easymode" to show what you can do.');
   ListBox1.Items.add (' ------ ');
   ListBox1.Items.add ('What do you do?');
   ListBox1.ItemIndex := ListBox1.Items.Count - 1;
   place := 0;
   hp := 100;
   enemyHP := 100;
   easymode := false;
end;

procedure Delay(milliSecondsDelay: int64);
// Sleep without program freezing
var
  stopTime : TDateTime;
begin
  stopTime := IncMilliSecond(Now,milliSecondsDelay);
  while (Now < stopTime) and (not Application.Terminated) do
    Application.ProcessMessages;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   inp: String;
   enemyAttack: Integer;
begin
   if key = 13 then begin
      inp := LowerCase(Edit1.Text);
      ListBox1.Items.Add(' ------ ');
      ListBox1.Items.Add('> ' + inp);
      Edit1.Text:='';
   end;

   // Southwest
   if place = 0 then begin
      if inp = 'go southwest' Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('This is a forest, with trees in all directions.');
         ListBox1.Items.add ('  To the east, there appears to be sunlight.');
         if easymode then begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.Add ('You can try to: go west; go north; ');
            ListBox1.Items.Add ('                go south; go east.');
         end;
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('What do you do?');
         place := 1;
      end
      else if inp = 'take mailbox' Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('It is securely anchored.');
      end
      else if inp = 'open mailbox' Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('Opening the small mailbox reveals a leaflet.');
      end
      else if inp = 'go east' Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('The door is boarded and you cannot remove the boards.');
      end
      else if inp = 'open door' Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('The door cannot be opened.');
      end
      else if (inp = 'take boards') or (inp = 'remove boards') Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('The boards are securely fastened.');
      end
      else if inp = 'look at house' Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('The house is a beautiful colonial house which is painted white.');
         ListBox1.Items.add ('It is clear that the owners must have been extremely wealthy.');
      end
      else if inp = 'read leaflet' Then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('WELCOME TO ZORQ!');
         ListBox1.Items.add ('Your mission is to find a Jade Statue.');
         ListBox1.Items.Add ('');
         ListBox1.Items.Add ('Zorq is loosely based on Zork.');
         ListBox1.Items.Add ('Source code available at https://github.com/gkeep/zorq');
         ListBox1.Items.Add ('Made by Gennady Koshkin (gkeep).');
      end
      else if inp = 'easymode' then begin
         easymode := True;
         if easymode then begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.Add ('You can try to: take mailbox; open mailbox; go east;');
            ListBox1.Items.Add ('                go southwest; look at house.');
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.add ('What do you do?');
         end
      end
   end

   // West
   else if place = 1 then begin
      if inp = 'go west' then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('You would need a machete to go further West.');
      end
      else if inp = 'go north' then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('The forest becomes impenetrable to the North.');
      end
      else if inp = 'go south' then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('Storm-tossed trees block your way.');
      end
      else if inp = 'go east' then begin
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('You are in a clearing, with a forest surrounding you on all sides.');
         ListBox1.Items.Add ('A path leads south.');
         ListBox1.Items.add ('There is an open grating, descending into darkness.');
         if easymode then begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.Add('You can try to: go south; descend grating');
         end;
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('What do you do?');
         place := 2;
      end
   end

   // ogre fight
   else if place = 2 then begin
      if inp = 'go south' then begin
         if enemyhp >= 0 then begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.add ('You see a large ogre.');
         end
         else begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.add ('You see a dead ogre.');
         end
      end
      else if (inp = 'attack ogre') or (inp = 'attack') and (enemyHP > 0) then begin
         ListBox1.Items.add (' ------ ');
         // show ogre's hp
         Label2.Visible := true;
         Edit3.Visible := true;

         Randomize;
         enemyAttack := Random(2)+1;

         if enemyAttack = 1 then begin
            ListBox1.Items.add ('You attack ogre, but deal no damage.');
            ListBox1.Items.Add ('');
            ListBox1.Items.Add ('Ogre counter-attacks and breaks one of your bones.');
            ListBox1.Items.Add ('');
            ListBox1.Items.Add ('-25 HP');

            hp := hp - 25;

            if hp < 0 then
               hp := 0;

            edit2.Text := IntToStr(hp)
         end
         else if enemyAttack = 2 then begin
            ListBox1.Items.add ('You punch ogre.');
            ListBox1.Items.Add ('');
            ListBox1.Items.Add ('-15 HP');

            enemyHP := enemyHP - 15;

            if enemyHP < 0 then
               enemyHP := 0;

            edit3.Text := IntToStr(enemyHP);
         end;

         if enemyHP <= 0 then begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.add ('You killed the ogre.');
            ListBox1.Items.Add ('');

            // hide ogre's hp
            Label2.Visible := false;
            Edit3.Visible := false;
         end;

         if hp <= 0 then begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.Add ('The ogre killed you.');
            place := 9;
         end
      end
         else if (inp = 'descend grating') or (inp = 'descend') then begin
               ListBox1.Items.add (' ------ ');
               ListBox1.Items.add ('  You are in a tiny cave with a dark, forbidding staircase leading down.');
               ListBox1.Items.add ('There is a skeleton of a human male in one corner.');
               if easymode then begin
                  ListBox1.Items.add(' ------ ');
                  ListBox1.Items.Add('You can try to: take skeleton; break skeleton;');
                  ListBox1.Items.Add('                suicide; descend staircase.');
               end;
               ListBox1.Items.add (' ------ ');
               ListBox1.Items.add ('What do you do?');
               place := 3;
         end;
   end

   // skeleton
   else if place = 3 then begin
      if inp = 'suicide' then begin
         ListBox1.Items.Add ('You throw yourself down the staircase as an attempt at suicide. You die.');
         place := 9;
      end
      else if (inp = 'take skeleton') or (inp = 'break skeleton') or (inp = 'smash skeleton') then begin
         ListBox1.Items.Add ('Why would you do that? Are you some sort of sicko?');
      end
      else if (inp = 'descend staircase') or (inp = 'scale staircase') or (inp = 'go down staircase') then begin
         ListBox1.Items.Add ('You have entered a mud-floored room.');
         ListBox1.Items.Add ('  Lying half buried in the mud is an old trunk, bulging with jewels.');
         if easymode then begin
            ListBox1.Items.add (' ------ ');
            ListBox1.Items.Add('You can try to: open trunk.');
         end;
         ListBox1.Items.add (' ------ ');
         ListBox1.Items.add ('What do you do?');
         place := 4;
      end;
   end

   // game's end
   else if place = 4 then begin
      if inp = 'open trunk' then begin
         ListBox1.Items.Add (' ------ ');
         ListBox1.Items.Add ('');
         ListBox1.Items.Add ('           You have found the Jade Statue and have completed your quest!');
         ListBox1.Items.Add ('');
         ListBox1.Items.Add ('Game will close in 10 seconds.');
         ListBox1.ItemIndex := ListBox1.Items.Count - 1;
         Delay(10000);
         Close;
      end
   end

   // player's death
   else if place = 9 then begin
      ListBox1.Items.Add (' ------ ');
      ListBox1.Items.Add ('GAME OVER.');
      ListBox1.Items.Add ('');
      ListBox1.Items.Add ('Game will close in 10 seconds.');
      Edit1.Enabled := false;
      Delay(10000);
      Close;
   end;

   inp := Edit1.Text;
   ListBox1.ItemIndex := ListBox1.Items.Count - 1;
end;

begin
end.
