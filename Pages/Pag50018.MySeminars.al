/// <summary>
/// Page My Seminars (ID 50018).
/// </summary>
page 50018 "My Seminars"
{
    ApplicationArea = All;
    Caption = 'My Seminars';
    PageType = ListPart;
    SourceTable = "My Seminar";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Seminar No. field.';

                    trigger OnValidate()
                    begin
                        SyncFieldsWithSeminar();
                    end;
                }
                field(Control4; Seminar.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Seminar Name field.';
                }
                field(Control5; Seminar."Seminar Duration")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Seminar Duration';
                    ToolTip = 'Specifies the value of the Seminar Duration field.';
                }
                field(Control6; Seminar."Seminar Price")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Seminar Price';
                    ToolTip = 'Specifies the value of the Seminar Price field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Open)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "Seminar Card";
                RunPageLink = "No." = FIELD("Seminar No.");
                RunPageMode = View;
                RunPageView = SORTING("No.");
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SyncFieldsWithSeminar();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Seminar)
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;

    var
        Seminar: Record Seminar;

    local procedure SyncFieldsWithSeminar()
    var
        MySeminar: Record "My Seminar";
    begin
        Clear(Seminar);

        if Seminar.Get(Rec."Seminar No.") then
            if MySeminar.Get(Rec."User ID", Rec."Seminar No.") then
                Rec.Modify();
    end;

}
