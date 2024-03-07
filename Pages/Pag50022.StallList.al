/// <summary>
/// Page Stall List (ID 50022).
/// </summary>
page 50022 "Stall List"
{
    ApplicationArea = All;
    Caption = 'Stalls';
    CardPageID = "Stall Card";
    Editable = false;
    PageType = List;
    QueryCategory = 'Stall List';
    SourceTable = Stall;
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Capacity; Rec.Capacity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Capacity field.';
                }
                field("Occupied (Number of Cattle)"; Rec."Occupied (Number of Cattle)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Number of Cattle Occupying the Stall.';
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("New Cattle")
            {
                ApplicationArea = All;
                Caption = 'New Cattle';
                Image = Document;
                RunObject = Page "Item Card";
                RunPageLink = "Stall No." = FIELD("No.");
                RunPageMode = Create;
                ToolTip = 'Create a Cattle for the Stall.';
            }
        }

        area(Navigation)
        {
            group(Stall)
            {
                action(Cattle)
                {
                    Caption = 'Cattle';
                    ApplicationArea = All;
                    Image = Customer;
                    RunObject = Page "Cattle List";
                    RunPageLink = "Stall No." = field("No.");
                    ToolTip = 'View the cattle for the stall selected.';
                }
            }
        }
    }
}
