/// <summary>
/// Page Stall Card (ID 50021).
/// </summary>
page 50021 "Stall Card"
{
    Caption = 'Stall Card';
    PageType = Card;
    SourceTable = Stall;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the value of the No. field.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Name field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Capacity; Rec.Capacity)
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Capacity field.';
                }
                field("Occupied (Number of Cattle)"; Rec."Occupied (Number of Cattle)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Number of Cattle Occupying the Stall.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
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
