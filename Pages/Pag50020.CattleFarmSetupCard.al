/// <summary>
/// Page Cattle Farm Setup Card (ID 50020).
/// </summary>
page 50020 "Cattle Farm Setup Card"
{
    ApplicationArea = All;
    Caption = 'Cattle Farm Setup';
    PageType = Card;
    SourceTable = "Cattle Farm Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Stall Nos."; Rec."Stall Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stall Nos. field.';
                }
                field("Cattle Preg. Nos."; Rec."Cattle Pregnancy Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cattle Pregnancy Nos. field.';
                }
                field("Milk Collection Nos."; Rec."Milk Collection Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Milk Collection Nos. field.';
                }
                field("Cattle Checkup Nos."; Rec."Cattle Checkup Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cattle Checkup Nos. field.';
                }
                field("Medical History Nos."; Rec."Medical History Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Medical History Nos. field.';
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
