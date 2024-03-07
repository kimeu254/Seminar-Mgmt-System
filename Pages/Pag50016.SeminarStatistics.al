/// <summary>
/// Page Seminar Statistics (ID 50016).
/// </summary>
page 50016 "Seminar Statistics"
{
    Caption = 'Seminar Statistics';
    PageType = Card;
    SourceTable = Seminar;
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                fixed(Control1904230801)
                {
                    ShowCaption = false;
                    group("This Period")
                    {
                        Caption = 'This Period';
                        field("SeminarDateName[1]"; SeminarDateName[1])
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                        }
                        field("TotalPrice[1]"; TotalPrice[1])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                            ToolTip = 'Specifies your total price in the fiscal year.';
                        }
                        field("TotalPriceNotChargeable[1]"; TotalPriceNotChargeable[1])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Not Chargeable)';
                            ToolTip = 'Specifies your total price not chargeable in the fiscal year.';
                        }
                        field("TotalPriceChargeable[1]"; TotalPriceChargeable[1])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Chargeable)';
                            ToolTip = 'Specifies your total price chargeable in the fiscal year.';
                        }
                    }
                    group("This Year")
                    {
                        Caption = 'This Year';
                        field(Text001; Text001)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field("TotalPrice[2]"; TotalPrice[2])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                            ToolTip = 'Specifies your total price in the fiscal year.';
                        }
                        field("TotalPriceNotChargeable[2]"; TotalPriceNotChargeable[2])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Not Chargeable)';
                            ToolTip = 'Specifies your total price not chargeable in the fiscal year.';
                        }
                        field("TotalPriceChargeable[2]"; TotalPriceChargeable[2])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Chargeable)';
                            ToolTip = 'Specifies your total price chargeable in the fiscal year.';
                        }
                    }
                    group("Last Year")
                    {
                        Caption = 'Last Year';
                        field(Placeholder1; Text001)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                            Visible = false;
                        }
                        field("TotalPrice[3]"; TotalPrice[3])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                            ToolTip = 'Specifies your total price in the fiscal year.';
                        }
                        field("TotalPriceNotChargeable[3]"; TotalPriceNotChargeable[3])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Not Chargeable)';
                            ToolTip = 'Specifies your total price not chargeable in the fiscal year.';
                        }
                        field("TotalPriceChargeable[3]"; TotalPriceChargeable[3])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Chargeable)';
                            ToolTip = 'Specifies your total price chargeable in the fiscal year.';
                        }
                    }
                    group("To Date")
                    {
                        Caption = 'To Date';
                        field(Placeholder2; Text001)
                        {
                            ApplicationArea = Basic, Suite;
                            Visible = false;
                        }
                        field("TotalPrice[4]"; TotalPrice[4])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                            ToolTip = 'Specifies your total price in the fiscal year.';
                        }
                        field("TotalPriceNotChargeable[4]"; TotalPriceNotChargeable[4])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Not Chargeable)';
                            ToolTip = 'Specifies your total price not chargeable in the fiscal year.';
                        }
                        field("TotalPriceChargeable[4]"; TotalPriceChargeable[4])
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Price (Chargeable)';
                            ToolTip = 'Specifies your total price chargeable in the fiscal year.';
                        }
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if CurrentDate <> WorkDate() then begin
            CurrentDate := WorkDate();
            DateFilterCalc.CreateAccountingPeriodFilter(SeminarDateFilter[1], SeminarDateName[1], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[2], SeminarDateName[2], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[3], SeminarDateName[3], CurrentDate, -1);
        end;

        SetDateFilter();

        for i := 1 to 4 do begin
            Rec.SetFilter("Date Filter", SeminarDateFilter[i]);
            Rec.CalcFields(
              "Total Price", "Total Price (Not Chargeable)", "Total Price (Chargeable)");
            TotalPrice[i] := Rec."Total Price";
            TotalPriceNotChargeable[i] := Rec."Total Price (Not Chargeable)";
            TotalPriceChargeable[i] := Rec."Total Price (Chargeable)";
        end;
        Rec.SetRange("Date Filter", 0D, CurrentDate);
    end;

    var
        DateFilterCalc: Codeunit "DateFilter-Calc";

        Text001: Label 'Placeholder';

    protected var
        SeminarDateFilter: array[4] of Text[30];
        SeminarDateName: array[4] of Text[30];
        CurrentDate: Date;
        TotalPrice: array[4] of Decimal;
        TotalPriceNotChargeable: array[4] of Decimal;
        TotalPriceChargeable: array[4] of Decimal;
        i: Integer;

    local procedure SetDateFilter()

    begin
        //SetRange("Date Filter", 0D, CurrentDate);

        OnAfterSetDateFilter(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetDateFilter(var Seminar: Record Seminar)
    begin
    end;
}