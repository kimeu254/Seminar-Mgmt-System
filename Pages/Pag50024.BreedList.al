/// <summary>
/// Page Breed List (ID 50024).
/// </summary>
page 50024 "Breed List"
{
    ApplicationArea = All;
    Caption = 'Breeds';
    PageType = List;
    SourceTable = Breed;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
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
                RunPageLink = "Breed Code" = FIELD("Code");
                RunPageMode = Create;
                ToolTip = 'Create a cattle for the breed.';
            }
        }

        area(Navigation)
        {
            group(Breed)
            {
                action(Cattle)
                {
                    Caption = 'Cattle';
                    ApplicationArea = All;
                    Image = Customer;
                    RunObject = Page "Cattle List";
                    RunPageLink = "Breed Code" = field("Code");
                    ToolTip = 'View the cattle for the breed selected.';
                }
            }
        }
    }
}
