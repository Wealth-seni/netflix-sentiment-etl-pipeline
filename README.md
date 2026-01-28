# netflix-sentiment-etl-pipeline
End-to-end data pipeline using Python, BERTopic and Local LLMs to analyze 145k+ Netflix reviews

The Core Challenge: Netflix receives thousands of daily reviews. Standard "Positive/Negative" analysis isn't enough. I built a pipeline that discovers why people are complaining using unsupervised machine learning.

## 🗺️ Project Roadmap
- [x] Phase 1: Python ETL & NLP Sentiment Engine (Current)

Technical Highlights:

Automated Sync: Integrated Kaggle API for daily data refreshes.

Incremental ETL: Built a "Delta Load" logic that only processes new reviews, reducing LLM compute time by 90%.

Advanced NLP: Used BERTopic for clustering and Ollama (Phi-3) to generate human-readable labels for thousands of review clusters.

- [ ] Phase 2: SQL Data Warehousing & Relational Modeling (Coming Soon)
- [ ] Phase 3: Brand-Aligned Power BI Executive Dashboard (Coming Soon)
- [ ] 
