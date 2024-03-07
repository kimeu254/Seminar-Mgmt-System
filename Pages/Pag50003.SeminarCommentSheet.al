/// <summary>
/// Page Seminar Comment Sheet (ID 50003).
/// </summary>
page 50003 "Seminar Comment Sheet"
{
    Caption = 'Seminar Comment Sheet';
    PageType = List;
    SourceTable = "Seminar Comment Line";
    UsageCategory = None;
    MultipleNewLines = true;
    LinksAllowed = false;
    DelayedInsert = true;
    DataCaptionFields = "No.";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Code field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetUpNewLine();
    end;
}
