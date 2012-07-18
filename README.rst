Replication code and data for "Volatility, diversification and development in the Gulf Cooperation Council countries"
==========================================================================================================================

Please cite as follows::

	Koren, Miklós and Silvana Tenreyro. 2012. 
	"Volatility, diversification and development in the Gulf Cooperation Council countries".
	Chapter 9 in David Held and Kristian Ulrichsen (eds), "The Transformation of the Gulf: Politics, Economics and the Global Order", Routledge.


Codes
-----
The Stata do file ``/code/gcc_volatility.do`` does all the calculations. It should be easy to rewrite to work with other data. The actual variance decomposition is implemented in ``/code/voldecomp.ado,`` which reproduces the methodology of Koren, Miklós and Silvana Tenreyro. 2007. "Volatility and Development." Quarterly Journal of Economics, 122(1):243-287, February 2007.

Please note that the notation of variables is somewhat different that in the QJE paper:

``idio``: 
	*Idiosyncratic risk* (``ISECT`` in the QJE). The total contribution of idiosyncratic shocks to aggregate variance.
``herf``: 
	*Herfindahl index* (``HERF`` in the QJE). The Herfindahl index of sectoral shares.
``isect``: 
	*Average idiosyncratic variance* (``AVAR`` in the QJE). The total contribution of idiosyncratic shocks to aggregate variance, divided by the Herfindahl index.

Data
----
``data/un/un2009.csv`` holds the United Nations *National Accounts Maing Aggregates Data* for our sample of GCC and control countries. Please go to http://unstats.un.org/unsd/snaama/Introduction.asp to download the entire dataset.

The spreadsheet ``/data/decomposition.csv`` has all the volatility components, country by country, year by year.


Updates since the published version
-----------------------------------

We have updated the data through 2009. This code *only* uses the GCC and the control countries throughout the analysis, dropping all other countries. This makes it easier to identify the global shock in the mining industry, because both GCC and control countries are oil rich. As a consequence, the role of global sectoral risk (``gsect``) is bigger than in the book version.



