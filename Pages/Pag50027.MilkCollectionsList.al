/// <summary>
/// Page Milk Collection (ID 50027).
/// </summary>
page 50027 "Milk Collections List"
{
    ApplicationArea = All;
    Caption = 'Milk Collections';
    PageType = List;
    SourceTable = "Milk Collection";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Milk Collection Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                    Importance = Additional;
                }
            }
        }
    }
}
