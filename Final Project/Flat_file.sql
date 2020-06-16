/**************************/
/**      FLAT FILE       **/
/**************************/
SELECT 
		airports.AIRPORT as DESTINATION_AIRPORT_NAME
		  ,airports.CITY as DESTINATION_CITY
		  ,airports.STATE as DESTINATION_STATE
		  ,airports.LATITUDE as DESTINATION_LAT
		  ,airports.LONGITUDE as DESTINATION_LONG
		  ,TEMP.* INTO all_flights
	 FROM
		(SELECT  
			  flights.YEAR
			  ,flights.MONTH
			  ,flights.DAY
			  ,flights.DAY_OF_WEEK
			  ,flights.FLIGHT_NUMBER
			  ,flights.TAIL_NUMBER
			  ,flights.ORIGIN_AIRPORT
			  ,flights.DESTINATION_AIRPORT
			  ,flights.SCHEDULED_DEPARTURE
			  ,flights.DEPARTURE_TIME
			  ,flights.DEPARTURE_DELAY
			  ,flights.TAXI_OUT
			  ,flights.WHEELS_OFF
			  ,flights.SCHEDULED_TIME
			  ,flights.ELAPSED_TIME
			  ,flights.AIR_TIME
			  ,flights.DISTANCE
			  ,flights.WHEELS_ON
			  ,flights.TAXI_IN
			  ,flights.SCHEDULED_ARRIVAL
			  ,flights.ARRIVAL_TIME
			  ,flights.ARRIVAL_DELAY
			  ,flights.DIVERTED
			  ,flights.CANCELLED
			  ,flights.CANCELLATION_REASON
			  ,flights.AIR_SYSTEM_DELAY
			  ,flights.SECURITY_DELAY
			  ,flights.AIRLINE_DELAY
			  ,flights.LATE_AIRCRAFT_DELAY
			  ,flights.WEATHER_DELAY
			  ,airlines.*
			  ,airports.AIRPORT as ORIGIN_AIRPORT_NAME
			  ,airports.CITY as ORIGIN_CITY
			  ,airports.STATE as ORIGIN_STATE
			  ,airports.COUNTRY
			  ,airports.LATITUDE as ORIGIN_LAT
			  ,airports.LONGITUDE as ORIGIN_LONG


		FROM flights 
		LEFT OUTER JOIN airlines ON flights.AIRLINE = airlines.IATA_CODE  
		LEFT OUTER JOIN airports ON flights.ORIGIN_AIRPORT = airports.IATA_CODE) AS TEMP

LEFT OUTER JOIN airports ON TEMP.DESTINATION_AIRPORT = airports.IATA_CODE 


/***********************************************************************************/