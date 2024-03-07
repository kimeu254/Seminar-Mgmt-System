/// <summary>
/// Page Seminar Manager Activities (ID 50017).
/// </summary>
page 50017 "Seminar Manager Activities"
{
    Caption = 'Seminar Manager Activities';
    PageType = CardPart;
    SourceTable = "Seminar Cue";
    ShowFilter = false;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(Registrations)
            {
                Caption = 'General';

                field(Planned; Rec.Planned)
                {
                    ApplicationArea = Seminars;
                    DrillDownPageId = "Seminar Registration List";
                    ToolTip = 'Specifies the value of the Planned field.';
                }
                field(Registered; Rec.Registered)
                {
                    ApplicationArea = Seminars;
                    DrillDownPageId = "Seminar Registration List";
                    ToolTip = 'Specifies the value of the Registered field.';
                }

                actions
                {
                    action(New)
                    {
                        ApplicationArea = Seminars;
                        Caption = 'New';
                        RunPageMode = Create;
                        RunObject = Page "Seminar Registration";
                        ToolTip = 'Create a New Seminar Registration';
                    }
                }
            }
            cuegroup(Posting)
            {
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Seminars;
                    DrillDownPageId = "Seminar Registration List";
                    ToolTip = 'Specifies the value of the Closed field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}