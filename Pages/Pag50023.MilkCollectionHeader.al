/// <summary>
/// Page Milk Collection Header (ID 50023).
/// </summary>
page 50023 "Milk Collection Header"
{
    Caption = 'Milk Collection Header';
    PageType = Document;
    SourceTable = "Milk Collection";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.';
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    ToolTip = 'Specifies the value of the Resource Name field.';
                }
                field("Total Amount (Ltrs)"; Rec."Total Amount (Ltrs)")
                {
                    ToolTip = 'Specifies the value of the Total Amount (Ltrs) field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
            }
            part("Milk Collection Subform"; "Milk Collection Subform")
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
}
