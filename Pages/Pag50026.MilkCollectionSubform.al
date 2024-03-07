/// <summary>
/// Page Milk Collection Subform (ID 50026).
/// </summary>
page 50026 "Milk Collection Subform"
{
    Caption = 'Milk Collection Subform';
    PageType = ListPart;
    SourceTable = "Milk Collection Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cattle No."; Rec."Cattle No.")
                {
                    ToolTip = 'Specifies the value of the Cattle No. field.';
                }
                field("Cattle Description"; Rec."Cattle Description")
                {
                    ToolTip = 'Specifies the value of the Cattle Description field.';
                }
                field("Amount Collected (Ltrs)"; Rec."Amount Collected (Ltrs)")
                {
                    ToolTip = 'Specifies the value of the Amount Collected (Ltrs) field.';
                }
                field("Fate Amount (Ltrs)"; Rec."Fate Amount (Ltrs)")
                {
                    ToolTip = 'Specifies the value of the Fate Amount (Ltrs) field.';
                }
                field("Total Amount (Ltrs)"; Rec."Total Amount (Ltrs)")
                {
                    ToolTip = 'Specifies the value of the Total Amount (Ltrs) field.';
                }
            }
        }
    }
}
