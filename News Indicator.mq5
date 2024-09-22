//+------------------------------------------------------------------+
//|                                               News Indicator.mq5 |
//|                                            Sibusiso Winston Moyo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

// These properties define metadata for the indicator and how it will be displayed on the chart
#property copyright "Sibusiso Winston Moyo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_plots 0
#property indicator_buffers 0  // No buffers as we are not plotting typical indicators

//+------------------------------------------------------------------+
//| Indicator settings inputs - users can customize visualization    |
//+------------------------------------------------------------------+
input string a = "-------INDICATOR SETTINGS-------"; // Aesthetic line to visually separate settings
input color Clr = clrBlue; // Line color for news events
input int lineWidth = 3;   // Line width for news event markers
input string c = "-------CSV DATA SETTINGS-------"; // Aesthetic separator for data settings
input string fileName = "Data New.csv"; // CSV file name to be read for news events

// Declare the base and quote currencies for comparison in the chart
string baseCurrency;
string quoteCurrency;

// Define a struct to hold the properties of each news event
struct Event
  {
   string            currency;    // Currency affected by the news event
   string            dateString;  // Date and time of the news event (in string format)
  };

// Array to hold all the news events read from the CSV file
Event newsArray[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Set the base and quote currencies for the current symbol (e.g. EUR/USD)
   baseCurrency = SymbolInfoString(_Symbol, SYMBOL_CURRENCY_BASE);  // EUR in EUR/USD
   quoteCurrency = SymbolInfoString(_Symbol, SYMBOL_CURRENCY_PROFIT);  // USD in EUR/USD

   return(INIT_SUCCEEDED);  // Initialization successful
  }
//+------------------------------------------------------------------+
//| Main calculation function - called every tick                    |
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
   // Check if the newsArray is empty, if so, populate it with news data
   if(ArraySize(newsArray) == 0)
     {
      populateNews(newsArray);  // Load news events from the CSV file
     }
   else
     {
      // Plot news events for both the base and quote currencies on the chart
      plotCalendarNews(baseCurrency);
      plotCalendarNews(quoteCurrency);
     }
   
   return(rates_total);  // Return the total number of rates for the next iteration
  }
//+------------------------------------------------------------------+
//| Function to plot news events for a given currency on the chart    |
//+------------------------------------------------------------------+
void plotCalendarNews(string currency)
  {
   // Loop through the news array and plot events that match the specified currency
   for(int i = 0; i < ArraySize(newsArray); i++)
     {
      if(currency == newsArray[i].currency)  // Match event currency with given currency
        {
         datetime newsEvent = dateParser(newsArray[i].dateString);  // Parse the date string to datetime format
         drawVLine(newsEvent, Clr, lineWidth);  // Draw a vertical line at the event time on the chart
        }
     }
  }
//+------------------------------------------------------------------+
//| Function to draw vertical lines on the chart for news events      |
//+------------------------------------------------------------------+
void drawVLine(datetime time, color clr, int width)
  {
   // Generate a unique name for each vertical line based on the event time and color
   string vLineName = "vLine" + (string)time + (string)clr;

   // Check if the vertical line already exists, if not, create it
   if(ObjectFind(0, vLineName) < 0)
     {
      ObjectCreate(0, vLineName, OBJ_VLINE, 0, time, 0);  // Create vertical line
      ObjectSetInteger(0, vLineName, OBJPROP_COLOR, clr);  // Set the line color
      ObjectSetInteger(0, vLineName, OBJPROP_WIDTH, width);  // Set the line width
     }
  }
//+------------------------------------------------------------------+
//| Cleanup function - called when the indicator is removed           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0);  // Remove all objects (vertical lines) when the indicator is removed
  }
//+------------------------------------------------------------------+
//| Function to parse date strings from the CSV file into datetime    |
//+------------------------------------------------------------------+
datetime dateParser(string dateT)
  {
   // Split the date and time string into its components (day, month, year, hour, minute)
   string split[];
   StringSplit(dateT, ' ', split);  // Split by space to separate date and time

   string split_split[];
   StringSplit(split[0], '.', split_split);  // Split date (day.month.year)

   string time_split[];
   StringSplit(split[1], ':', time_split);  // Split time (hour:minute)

   MqlDateTime dtt;
   dtt.year = (int)split_split[2];
   dtt.mon = (int)split_split[1];
   dtt.day = (int)split_split[0];
   dtt.hour = (int)time_split[0];
   dtt.min = (int)time_split[1];

   // Convert the structured date and time to datetime format
   datetime dt = StructToTime(dtt);

   return dt;
  }
//+------------------------------------------------------------------+
//| Function to populate the news event array from the CSV file       |
//+------------------------------------------------------------------+
void populateNews(Event& newsArr[])
  {
   string stringArr[];  // Temporary array to hold the file's content
   int file = FileOpen("News Data/" + fileName, FILE_READ|FILE_CSV|FILE_COMMON|FILE_ANSI);  // Open the CSV file
   FileReadString(file);  // Skip the header row

   // Read the CSV file line by line and store the data in stringArr
   while(!FileIsEnding(file))
     {
      ArrayResize(stringArr, ArraySize(stringArr) + 1);  // Resize array for each new line
      stringArr[ArraySize(stringArr)-1] = FileReadString(file);  // Read each line
     }
   FileClose(file);  // Close the file

   // Resize the news array and populate it with the parsed CSV data
   if(ArraySize(stringArr) > 0)
     {
      ArrayResize(newsArr, ArraySize(stringArr));

      for(int i = 0; i < ArraySize(stringArr); i++)
        {
         string splitty[];
         StringSplit(stringArr[i], ',', splitty);  // Split each line by commas (CSV format)

         if(ArraySize(splitty) > 0)
           {
            newsArr[i].currency = splitty[0];     // Store the currency (first field)
            newsArr[i].dateString = splitty[3];   // Store the date/time (fourth field)
           }
        }
     }
  }
//+------------------------------------------------------------------+
