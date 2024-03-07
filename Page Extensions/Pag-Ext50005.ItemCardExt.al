/// <summary>
/// PageExtension Item Card Ext (ID 50005) extends Record Item Card.
/// </summary>
pageextension 50005 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(Type)
        {
            field("Farm Item Type"; Rec."Farm Item Type")
            {
                ToolTip = 'Specifies the value of the Farm Item Type field.';

                trigger OnValidate()
                begin
                    EnableControls();
                end;
            }
        }
        addafter(Item)
        {
            group("Cattle Information")
            {
                Visible = IsCattle;
                field("Adult / Calf"; Rec."Adult / Calf")
                {
                    ToolTip = 'Specifies the value of the Adult / Calf field.';

                    trigger OnValidate()
                    begin
                        EnableControls();
                    end;
                }
                field("Breed No."; Rec."Breed Code")
                {
                    ToolTip = 'Specifies the value of the Breed Code field.';
                }
                field("Breed Name"; Rec."Breed Description")
                {
                    ToolTip = 'Specifies the value of the Breed Description field.';
                }
                field("Stall No."; Rec."Stall No.")
                {
                    ToolTip = 'Specifies the value of the Stall No. field.';
                }
                field("Stall Name"; Rec."Stall Name")
                {
                    ToolTip = 'Specifies the value of the Stall Name field.';
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Weight (Kgs)"; Rec."Weight (Kgs)")
                {
                    ToolTip = 'Specifies the value of the Weight (Kgs) field.';
                }
                field("Height (Centimeters)"; Rec."Height (Centimeters)")
                {
                    ToolTip = 'Specifies the value of the Height (Centimeters) field.';
                }
                field("Age (Months)"; Rec."Age (Months)")
                {
                    ToolTip = 'Specifies the value of the Age (Months) field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group(Calf)
            {
                Visible = IsCalf;
                field("Birth Date"; Rec."Birth Date")
                {
                    ToolTip = 'Specifies the value of the Birth Date field.';
                }

                field("Parent No."; Rec."Parent No.")
                {
                    ToolTip = 'Specifies the value of the Parent No. field.';
                }
                field("Parent Description"; Rec."Parent Description")
                {
                    ToolTip = 'Specifies the value of the Parent Description field.';
                }
                field("Parent Age"; Rec."Parent Age")
                {
                    ToolTip = 'Specifies the value of the Parent Age field.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableControls();
    end;

    protected var
        IsCattle: Boolean;
        IsAdult: Boolean;
        IsCalf: Boolean;

    /// <summary>
    /// EnableControls.
    /// /// </summary>
    procedure EnableControls()
    begin
        IsCattle := Rec.IsCattle();
        IsAdult := Rec.IsAdultType();
        IsCalf := Rec.IsCalfType();
    end;
}
