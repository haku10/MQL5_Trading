//+------------------------------------------------------------------+
//|                                                     MySignal.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot MA
#property indicator_label1  "MA"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot SigSell
#property indicator_label2  "SigSell"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrFuchsia
#property indicator_style2  STYLE_SOLID
#property indicator_width2  5
//--- plot SigBuy
#property indicator_label3  "SigBuy"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrAqua
#property indicator_style3  STYLE_SOLID
#property indicator_width3  5
//--- input parameters
input int     MAPeriod = 12;
//--- indicator buffers
double         MABuffer[];
double         SigSellBuffer[];
double         SigBuyBuffer[];
int ExtHandler = 0; //iMA(移動平均線)の値
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,MABuffer,INDICATOR_DATA);
   SetIndexBuffer(1,SigSellBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,SigBuyBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(1,PLOT_ARROW,242);
   PlotIndexSetInteger(2,PLOT_ARROW,241);
   Print("インジケータの開始");
   
   ExtHandler = iMA(_Symbol,_Period, MAPeriod, 0, MODE_SMA,PRICE_CLOSE);
   if(ExtHandler == INVALID_HANDLE){
   printf("Error creating MA indicator");
   return(INIT_FAILED);
   }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  int ret = 0;
  
  if(BarsCalculated(ExtHandler) >= rates_total){
   if(CopyBuffer(ExtHandler,0,0,rates_total, MABuffer) == rates_total){
      for(int i = 0; i < rates_total ; i++){
      SigSellBuffer[i] = EMPTY_VALUE;
      SigBuyBuffer[i] = EMPTY_VALUE;
      //サインの条件
      if(open[i] > MABuffer[i] && close[i] < MABuffer[i]){
         SigSellBuffer[i] = close[i];
      } else if(open[i] < MABuffer[i] && close[i] > MABuffer[i]){
         SigBuyBuffer[i] = close[i];
         }
      }
      ret = rates_total;
   }
  }
   
   return(ret);
  }
//+------------------------------------------------------------------+
