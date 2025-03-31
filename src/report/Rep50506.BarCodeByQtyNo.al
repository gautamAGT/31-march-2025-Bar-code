report 50506 BarCodeByQtyNo
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Bar code by qty';
    RDLCLayout = './quantityBarCode.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Item_; "No.") { }
                column(Quantity; Quantity) { }
                column(ItemGlobalVar; ItemGlobalVar) { }

                dataitem(Integer; Integer)
                {
                    DataItemLinkReference = "Purchase Line";
                    // DataItemTableView = SORTING(Number);

                    column(LabelNumber; Number) { }

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, "Purchase Line".Quantity);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        BarCodeQty();
                    end;
                }
            }
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                // group(GroupName)
                // // {
                // //     field(Name; SourceExpression)
                // //     {

                //     //     }
                // }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    procedure BarCodeQty()
    var
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeString: Code[50];


    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;


        BarcodeString := "Purchase Line"."No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        ItemGlobalVar := BarcodeFontProvider.EncodeFont("Purchase Line"."No.", BarcodeSymbology);



    end;



    var
        ItemGlobalVar: Text;


}