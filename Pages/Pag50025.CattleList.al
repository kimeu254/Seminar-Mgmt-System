/// <summary>
/// Page Cattle List (ID 50025).
/// </summary>
page 50025 "Cattle List"
{
    ApplicationArea = All;
    Caption = 'Cattle';
    CardPageId = "Item Card";
    Editable = false;
    PageType = List;
    QueryCategory = 'Cattle List';
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Adult / Calf"; Rec."Adult / Calf")
                {
                    ToolTip = 'Specifies the value of the Adult / Calf field.';
                }
                field("Breed Name"; Rec."Breed Description")
                {
                    ToolTip = 'Specifies the value of the Breed Description field.';
                }
                field("Stall Name"; Rec."Stall Name")
                {
                    ToolTip = 'Specifies the value of the Stall Name field.';
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Age (Months)"; Rec."Age (Months)")
                {
                    ToolTip = 'Specifies the value of the Age field.';
                }
                field("Weight (Kgs)"; Rec."Weight (Kgs)")
                {
                    ToolTip = 'Specifies the value of the Weight (Kgs) field.';
                }
                field("Farm Entry Date"; Rec."Farm Entry Date")
                {
                    ToolTip = 'Specifies the value of the Farm Entry Date field.';
                }
                field("Current Value"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Current Value field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("Farm Item Type", 'Cattle');
    end;
}
